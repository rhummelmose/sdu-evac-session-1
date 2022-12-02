terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "~> 2.13.0"
        }
    }
}

provider docker {}

resource docker_image backend_image {
    name = "sdu-evac-backend"
    build {
        path = "${var.path_sdu_evac_folder}/Backend"
        tag = ["sdu-evac-backend:terraform"]
    }
}

resource docker_image frontend_image {
    name = "sdu-evac-frontend"
    build {
        path = "${var.path_sdu_evac_folder}/Frontend"
        tag = ["sdu-evac-frontend:terraform"]
        build_arg = {
          "BACKEND_URL" = "http://localhost:3001"
        }
    }
}

resource docker_image mongo_image {
    name = "mongo:latest"

}

resource docker_image redis_image {
    name = "redis:latest"
}

resource docker_network private_network {
    name = "sdu-evac-network"
}

resource docker_container redis_container {
    name = "redis-container"
    image = "redis:latest"
    ports {
        internal = "6379"
        external = "6300"
    }
    networks_advanced {
        name = docker_network.private_network.name
        aliases = [ "redis" ]
    }
}

resource docker_container mongo_container {
    name = "mongo-container"
    image = "mongo:latest"
    ports {
        internal = "27017"
        external = "27020"
    }
    networks_advanced {
        name = docker_network.private_network.name
        aliases = [ "mongo" ]
    }
}

resource docker_container backend_container {
    name = "backend-container"
    image = "sdu-evac-backend:terraform"
    ports {
        internal = "80"
        external = "3000"
    }
    networks_advanced {
        name = docker_network.private_network.name
        aliases = [ "backend" ]
    }
    env = [
        "PORT=80",
        "MONGO_DB_CONNECTION_STRING=mongodb://mongo:27017",
        "MONGO_DB_NAME=sdu-evac",
        "REDIS_URI=redis://redis"
    ]
}

resource docker_container frontend_container {
    name = "frontend-container"
    image = "sdu-evac-frontend:terraform"
    ports {
        internal = "80"
        external = "3002"
    }
    networks_advanced {
        name = docker_network.private_network.name
        aliases = [ "frontend" ]
    }
}
