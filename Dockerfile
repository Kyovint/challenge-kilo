FROM python:3.11-slim

WORKDIR /app

RUN useradd -m appuser

RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

USER appuser
ENV POETRY_HOME="/home/appuser/.local"
ENV PATH="$POETRY_HOME/bin:$PATH"

RUN curl -sSL https://install.python-poetry.org | python3 -

COPY --chown=appuser:appuser ./py/server /app

RUN poetry install

EXPOSE 5001

CMD ["poetry", "run", "gunicorn", "--bind", "0.0.0.0:5001", "server.app:app"]
