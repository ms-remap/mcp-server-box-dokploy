FROM python:3.13-slim

WORKDIR /app

# System packages
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# Copy project files
COPY pyproject.toml uv.lock ./
COPY src ./src

# Install dependencies into a virtual environment managed by uv
RUN uv sync --frozen

# Copy any remaining project files if needed
COPY . .

# Run the MCP server
CMD ["uv", "run", "src/mcp_server_box.py"]
