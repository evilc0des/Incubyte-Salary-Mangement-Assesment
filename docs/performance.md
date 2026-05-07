# Performance Considerations

## Performance target I designed for

I treated 10,000 seeded employees as the baseline workload because that was enough to force real query and ingestion decisions without turning the assessment into a distributed systems exercise.

My goal was not extreme optimization. My goal was to avoid obviously fragile choices while keeping the code straightforward.

## Write path considerations

### Batched seeding

The seeder inserts employee records in batches rather than one row at a time. This reduces ORM overhead and transaction churn during initial data loading.

Why it matters:

- 10,000 single-row inserts would create unnecessary round trips and commit overhead.
- Batched inserts keep the seed workflow fast enough for repeated local setup.

### Deterministic generation

I used a fixed random seed by default so seed runs are reproducible. That makes it easier to reason about performance changes and test failures because the dataset shape stays stable unless I intentionally vary it.

## Read path considerations

### Search support

Employee search is implemented against `full_name`, and the database schema includes a trigram-backed GIN index. This supports substring-style search better than a plain B-tree index would.

### Composite insight index

I added a composite index on `(country, job_title, salary)` because those fields appear together in filtering, grouping, and analytics-oriented access patterns. That gives the backend a better starting point for insight-related reads than indexing salary alone.

### Pagination limits

Employee listing is paginated with bounded limits. This protects the API from accidentally returning very large result sets to the UI and keeps page rendering predictable.

## API and frontend considerations

### Server-side fetching for dashboard pages

The Next.js pages fetch dashboard data on the server. That reduces client work at first render and keeps data orchestration out of the browser for the initial page load.

### Parallel reads where it helps

The overview page loads several independent insight calls concurrently. I chose that because the charts and summary cards do not need to wait on each other, so parallel fetches reduce total wall-clock time for the page.

### Graceful partial failure

The overview page uses settled promises and can still render partial content if one analytics call fails. That is more of an availability choice than a raw performance optimization, but it helps keep the dashboard useful under partial degradation.

## Current bottlenecks and limits

The current analytics design loads relevant employee sets into Python and calculates several metrics in memory. For the current assessment size, that is acceptable and simpler to verify.

If the dataset or concurrency increased significantly, I would expect the next bottlenecks to be:

1. In-memory analytics work on large slices of employee data.
2. Offset pagination at higher offsets.
3. Recomputing the same dashboard aggregates repeatedly.

## What I would optimize next

If profiling showed the dashboard slowing down, I would prioritize improvements in this order:

1. Move the heaviest grouped analytics into SQL for the exact endpoints that need it.
2. Cache stable dashboard aggregates or precompute them on a schedule.
3. Revisit pagination strategy for the employee directory.
4. Add query timing and application metrics so optimizations are based on measurements instead of assumptions.