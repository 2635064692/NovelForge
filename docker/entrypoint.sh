#!/bin/bash
set -e

BACKEND_DIR="/app/backend"
FRONTEND_DIR="/app/frontend"

# --- Backend: venv + deps ---
if [ ! -f "$BACKEND_DIR/.venv/bin/activate" ]; then
    echo "[novelforge] Creating venv and installing backend deps..."
    python -m venv "$BACKEND_DIR/.venv"
    # shellcheck disable=SC1091
    source "$BACKEND_DIR/.venv/bin/activate"
    pip install -r "$BACKEND_DIR/requirements.txt"
else
    source "$BACKEND_DIR/.venv/bin/activate"
fi

# --- .env ---
if [ ! -f "$BACKEND_DIR/.env" ]; then
    echo "[novelforge] Copying .env.example -> .env"
    cp "$BACKEND_DIR/.env.example" "$BACKEND_DIR/.env"
fi

# --- Frontend: deps ---
if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
    echo "[novelforge] Installing frontend deps..."
    cd "$FRONTEND_DIR" && npm install
fi

# --- Start backend ---
echo "[novelforge] Starting backend on :54321 ..."
cd "$BACKEND_DIR"
python main.py &
BACKEND_PID=$!

# --- Start frontend (web mode) ---
echo "[novelforge] Starting frontend on :5173 ..."
cd "$FRONTEND_DIR"
VITE_APP_PLATFORM=web npx vite dev -c vite.config.web.ts --host 0.0.0.0 &
FRONTEND_PID=$!

# Wait for first exit, then kill the other
wait -n
kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
