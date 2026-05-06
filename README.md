# Salary Management HR Dashboard

A high-performance, minimal salary management system designed for HR Managers to oversee organizations of 10,000+ employees. Built with a focus on fast data ingestion and real-time salary analytics.

## Tech stack
   -Backend: FastAPI, SQLAlchemy 2.x, Alembic
   -Frontend: Next.js App Router, TypeScript
   -Database: PostgreSQL
   -Orchestration: Docker Compose

The scaffold is organized so backend/ and frontend/ can live as separate repositories and later be composed into this parent repository using git submodules. This keeps the orchestration repo clean while letting backend and frontend evolve independently if the project grows into separate delivery streams.

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

This repository has `backend\` and `frontend\` attached as submodules, clone everything in one step:

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
   - Backend docs: `http://localhost:8000/docs`
   - Backend health: `http://localhost:8000/api/v1/health`

## Notes

- The backend runs Alembic migrations automatically when started through Docker Compose.
- The frontend is wired through `NEXT_PUBLIC_API_URL` and does not require the backend to be reachable during the build step.
- PostgreSQL uses a named Docker volume for persistent local data.

