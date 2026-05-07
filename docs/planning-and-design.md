# Planning And Design Notes

## Problem framing

I treated this as a small but production-leaning HR dashboard rather than a pure CRUD exercise. The assessment wanted a system for an HR manager responsible for 10,000+ employees, so I optimized for three things early:

1. A backend that can ingest and query a non-trivial employee dataset quickly.
2. A frontend that can render a useful dashboard with minimal client complexity.
3. A structure that stays easy to explain in an interview or assessment review.

That framing led me to keep the architecture intentionally narrow: a Next.js dashboard, a FastAPI service, and PostgreSQL as the source of truth.

## Functional slices I prioritized

I broke the work into four slices and implemented them in roughly this order:

1. Establish the backend foundation: app bootstrapping, database session management, models, schemas, and migrations.
2. Model the employee lifecycle: employee CRUD, validation, and searchable list endpoints.
3. Add the business-facing value: salary insights, grouped analytics, and trend-style reporting.
4. Build a frontend that consumes the API server-side first, then progressively enhances the presentation.

This ordering let me keep each layer testable before moving on to the next one.

## Design principles I followed

### Keep the data model simple

I used a single `employees` table for the core assessment scope. I did not introduce extra normalization for countries, departments, or job titles because the extra tables would add schema and API complexity without adding much value for the current feature set.

### Put correctness close to the data

I enforced important rules in the database model and migration layer, not just in request validation. Examples include positive salary checks, fixed-width currency codes, computed `full_name`, UUID primary keys, and automatic `updated_at` handling.

### Favor server-rendered dashboard reads

For the main dashboard pages, I preferred server-side data fetching in Next.js. That keeps the browser light, reduces client-side orchestration code, and makes the initial page load show meaningful content even without a separate client state layer.

### Keep assessment reasoning visible

I kept the code split into clear backend and frontend applications and added Docker Compose at the top level so the project can be explained quickly: one UI, one API, one database, one orchestration layer.

### Keep the repository boundaries realistic

I chose a Git submodule-friendly structure because I wanted the assessment to reflect how I would separate concerns on a real team. The backend and frontend are independently runnable applications with their own dependencies, test workflows, and release cadence, while the root repository acts as the composition layer.

That choice gave me a few practical benefits:

- It keeps backend and frontend ownership boundaries explicit.
- It avoids turning the top-level repository into an oversized mixed-codebase application.
- It makes it easier to imagine promoting either application into its own delivery pipeline later.
- It keeps Docker Compose, shared setup notes, and cross-app orchestration in one place.

For the assessment, this is partly an architectural signal. I wanted to show that I was thinking not only about the code that runs today, but also about how the project would stay maintainable if the frontend and backend started evolving at different speeds.

## Scope decisions I made deliberately

I chose not to build the following in the first pass:

- Authentication and authorization
- Write workflows in the frontend UI
- Background jobs or asynchronous processing
- Caching layers such as Redis
- Materialized analytics tables
- Multi-currency handling beyond a fixed default currency

Those are all reasonable next steps in a real product, but each one would broaden the surface area enough to dilute the core assessment.

## Quality strategy

I wanted fast feedback without depending on a fully provisioned environment for every test run, so I used two testing lanes:

- A fast lane for API behavior and frontend rendering
- An integration lane for PostgreSQL-specific behavior, migrations, and seeded database workflows

This was important because a few implementation choices are intentionally database-aware, especially the Postgres extensions, computed columns, and trigger-based timestamp updates.

## What I would do next

If I were extending this beyond the assessment, my next steps would be:

1. Add authentication and role-based access.
2. Move employee list pagination and filtering toward cursor-based pagination if the dataset grows materially.
3. Revisit analytics execution paths and shift some grouped calculations into SQL if profiling shows Python-side aggregation becoming the bottleneck.
4. Add observability around API latency, seed duration, and query timings.