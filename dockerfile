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
RUN pytest

# production stage 
FROM python:3.12-alpine AS production 

# build-time argument (passed during docker build)
ARG NAME="Aziz"

# convert build argument into environment variable
ENV NAME=$NAME 

# set working directory 
WORKDIR /app 

# copy files
COPY app.py . 
COPY pyproject.toml .

# install only production dependencies
RUN pip install --no-cache-dir . 

# default command to run the application 
CMD ["python", "app.py"]