# Dashboard with Haskell and React

Visualize customer data that is stored in a CSV file:

<img width="1116" alt="Screenshot" src="https://github.com/user-attachments/assets/b5d55acb-1dd1-4494-9c51-d404669e8e7c">

## 1. About the Project

Given: a dataset that contains the name, company, address and contact information of 500 people in the US (randomly generated).
Dataset: `us-500.csv` source from [Free Sample Data - BrianDunning.com](https://www.briandunning.com/sample-data/)

Task:

1. Create a web interface that retrieves and displays the dataset in the table.

2. Search people based on two given inputs: search field and target value
- For example, if the search field is state and the target value is NY, the result table should contain all people in the dataset who live in NY state.
- If searched by first_name (e.g., Valentine) with a single result, display the user icon (user.png) with information about that person instead of the table.
- If searched by company_name (e.g., Printing Dimensions) with a single result, display the video (example.mp4) along with other information like company name and address.

3. Show summary statistics, such as the number of people per state

4. Create a visualization to show the distribution of the people across the US, which can depend on the state or zip code.


## 2. Tech Stacks

- Frontend:
  - Language:
    - TypeScript (JavaScript)
  - Frameworks/Libraries:
    - React.js
    - Tailwind CSS
- Backend:
  - Language:
    - Haskell
  - Frameworks/Libraries:
    - Scotty
- Deployment:
    - Linux Server
    - Docker
    - Nginx
- CI/CD:
    - GitHub Actions

## 3. Run the Project

1. Install Docker and Docker Compose

2. Run the following commands:

```bash
# Go to the project directory:
$ cd path/to/dashboard-haskell-react
# Pull the latest images specified in docker-compose.prod.yml:
$ docker-compose -f docker-compose.prod.yml pull
# Run the containers with Docker Compose in detached mode:
$ docker-compose -f docker-compose.prod.yml up -d
```

3. The project now is running at http://localhost:3005


## 4. Build the Docker Images

### 4.1 Build the Docker Images Locally (Development)

Install Docker and Docker Compose, then run the following commands:

```bash
# Go to the project directory:
$ cd path/to/dashboard-haskell-react
# Build the container without using cache:
$ docker compose build --no-cache
```

```bash
# Run the container in the background (detached mode):
$ docker compose up -d
# The project now is running at http://localhost:3005
# Stop the container:
$ docker compose down
```

### 4.2 Build the Docker Images with GitHub Actions (Production)

Details: check out `.github/workflows/docker_build.yml`
