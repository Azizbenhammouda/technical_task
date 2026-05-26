# development stage: used for building and testing the application
FROM python:3.12-alpine AS development

# set working directory inside the container
WORKDIR /app

# copy dependency file first (for better caching)
COPY pyproject.toml .

# install dependencies (including pytest)
RUN pip install --no-cache-dir .[dev]

# copy application source code
COPY app.py .

# copy test files
COPY tests/ ./tests/

# run tests to ensure everything works before production build
RUN python -m pytest

# production stage
FROM python:3.12-alpine AS production

# build-time argument (passed during docker build)
ARG NAME="Aziz"

# convert build argument into environment variable
ENV NAME=$NAME

# set working directory
WORKDIR /app

# copy installed packages from the development stage
COPY --from=development /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=development /usr/local/bin /usr/local/bin

# copy only the production application file (leaving tests behind)
COPY app.py ./

# Define the default runtime command
CMD ["python", "app.py"] 
