# Nginx Configuration on a Linux Server

Use Nginx as a reverse proxy to serve a TypeScript/React frontend and a Haskell backend on the same domain.

## 1. Create a new file dashboard-haskell-react in the /etc/nginx/sites-available directory:
```bash
$ sudo vim /etc/nginx/sites-available/dashboard-haskell-react
```

## 2. Add the following configuration:

```conf
# /etc/nginx/sites-available/dashboard-haskell-react

# Define a server block.
server {
    # Listen on port 80 (default HTTP port).
    listen 80;

    # Define the domain name(s).
    server_name dashboard-haskell-react.qingquanli.com;

    # Define the location for the APIs (Haskell backend).
    location /api {
        proxy_pass http://localhost:8005;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Define the location for the root URL (TypeScript/React frontend).
    location / {
        proxy_pass http://localhost:3005;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```


## 3. Create a symbolic link to the file in the /etc/nginx/sites-enabled directory:
```bash
$ sudo ln -s /etc/nginx/sites-available/dashboard-haskell-react /etc/nginx/sites-enabled/
```

## 4. Test the Nginx configuration:
```bash
$ sudo nginx -t
```


## 5. Reload Nginx to apply the changes:
```bash
$ sudo systemctl reload nginx
```


## 6. Optional: Configure HTTPS

- Use Cloudflare DNS proxy to enable HTTPS (it can also enable to hide the IP address of the server)
- Or: Configure Let's Encrypt (certbot) in Nginx to enable HTTPS
