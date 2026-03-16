#!/bin/bash

# 1. Create and enter the "host" parent directory
echo "Creating host directory..."
mkdir -p host
cd host || exit

# 2. Define the config folder (your 'etc' equivalent)
CONF_DIR="./caddy_config"

# 3. Create the folder if it doesn't exist
if [ ! -d "$CONF_DIR" ]; then
    echo "Creating directory: $CONF_DIR"
    mkdir -p "$CONF_DIR"
fi

# 4. Create a basic Caddyfile if it doesn't exist
if [ ! -f "$CONF_DIR/Caddyfile" ]; then
    echo "Creating default Caddyfile..."
    cat <<EOF > "$CONF_DIR/Caddyfile"
:80 {
    respond "Gridlogic Test OK"
}
EOF
fi

# 5. Generate the docker-compose.yml
echo "Generating docker-compose.yml..."
cat <<EOF > docker-compose.yml
services:
  caddy:
    image: caddy:latest
    container_name: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      # This maps your local 'caddy_config' to the container's '/etc/caddy'
      - ./caddy_config:/etc/caddy
      - caddy_data:/data
      - caddy_config:/config

volumes:
  caddy_data:
  caddy_config:
EOF

# 6. Launch
echo "Deployment complete. Starting containers..."
docker compose up -d

echo "C'est fini! Everything is inside the 'host' folder."
