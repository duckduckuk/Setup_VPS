secure.server.com {
    # 1. SSL Setup
    tls your-email@something.com

    # 2. Basic Auth - Move this to the top of the block
    # Use * to catch everything, regardless of subpaths
    basicauth * {
        <username> <hashedpassword> 
    }

    # 3. Redirect root to subfolder
    redir / /guacamole/ 308

    # 4. Proxy to home LXC
    reverse_proxy <ip.ip.ip.ip:port> {
        flush_interval -1
        header_up Host {host}
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-For {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}

HASH COMMAND: caddy hash-password --plaintext "passwordhere"
