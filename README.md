# Salary Management HR Dashboard

A high-performance, minimal salary management system designed for HR Managers to oversee organizations of 10,000+ employees. Built with a focus on fast data ingestion and real-time salary analytics.

*Live DEMO*: https://incubyte-salary-management-dk.up.railway.app/

## Tech stack
   -Backend: FastAPI, SQLAlchemy 2.x, Alembic
   -Frontend: Next.js App Router, TypeScript
   -Database: PostgreSQL
   -Orchestration: Docker Compose

The scaffold is organized so backend/ and frontend/ can live as separate repositories and be composed into this parent repository using git submodules. I chose that structure to keep each application independently developable and testable while reserving the root repository for orchestration concerns such as Docker Compose, shared setup, and assessment-level documentation. It keeps the composition repo clean while letting backend and frontend evolve independently if the project grows into separate delivery streams.

## Repository layout

```text
.
├── backend/            # FastAPI application & Seeding logic
│   ├── app/            # API routes & SQLAlchemy models
│   ├── alembic/        # Database migrations
│   └── scripts/        # High-performance seed script
├── frontend/           # Next.js application
│   └── src/            # Components, Hooks, and Dashboard UI
├── data/               # Source files for seeding
│   ├── first_names.txt
│   └── last_names.txt
├── scripts/            # Utility scripts
│   └── setup-submodules.ps1
├── .env.example
├── docker-compose.yml
└── README.md
```

## Clone from GitHub

This repository has `backend\` and `frontend\` attached as submodules.

*backend*: https://github.com/evilc0des/Incubyte-Salary-Management-Assesment-Backend
*frontend*: https://github.com/evilc0des/Incubyte-Salary-Management-Assesment-Frontend


Clone everything in one step:

```powershell
git clone --recurse-submodules <repo-url>
```

If you already cloned the parent repository without submodules, initialize them with:

```powershell
git submodule update --init --recursive
```

## Local development

1. Copy `.env.example` to `.env`.
2. Start the stack:

   ```powershell
   docker compose up --build
   ```

3. Open:
   - Frontend: `http://localhost:3000`
   - Backend Swagger docs: `http://localhost:8000/docs`
   - Backend ReDoc: `http://localhost:8000/redoc`
   - Backend OpenAPI schema: `http://localhost:8000/openapi.json`
   - Backend health: `http://localhost:8000/api/v1/health`

## Assessment artifacts

To document my reasoning for the assessment, I added a small set of notes under `docs/assessment/`:

- `docs/assessment/planning-and-design.md`
- `docs/assessment/architecture.md`
- `docs/assessment/trade-offs.md`
- `docs/assessment/performance.md`

## Notes

- The backend runs Alembic migrations automatically when started through Docker Compose.
- The frontend uses `INTERNAL_API_URL` for server-side App Router fetches and `NEXT_PUBLIC_API_URL` for browser-visible URLs. In Docker Compose, `INTERNAL_API_URL` is pinned to the backend service name so server-rendered frontend pages can reach the backend container.
- PostgreSQL uses a named Docker volume for persistent local data.

