# backend

## Run the Backend Locally

Install [Haskell Stack](https://docs.haskellstack.org/en/stable/), then run the following commands:

```bash
cd path/to/dashboard-haskell-react/backend

# Build the project
stack build

# Run the project
stack exec backend-exe
```

The backend will be running at `http://localhost:8080`
View the `api/data` endpoint at `http://localhost:8080/api/data`
