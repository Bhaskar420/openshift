# Use Nginx official base image
FROM nginx:stable-alpine

# Create a directory for application content
RUN mkdir -p /usr/share/nginx/html/app

# Copy application files into directory
COPY . /usr/share/nginx/html/app

# Change ownership of app directory to a user ID 1001 (common OpenShift non-root user)
RUN chown -R 1001:0 /usr/share/nginx/html/app \
    && chmod -R 755 /usr/share/nginx/html/app

# Change permissions of nginx files to be readable by group 0 (root group)
RUN chown -R 1001:0 /var/cache/nginx /var/run /var/log/nginx \
    && chmod -R g+rwx /var/cache/nginx /var/run /var/log/nginx
# user is root
USER root
# Switch to non-root user (UID 1001) as recommended by OpenShift
USER 1001

# Expose port 8080 or 80 depending on OpenShift route configuration
EXPOSE 8080

# Default Nginx entrypoint and command remain the same
CMD ["nginx", "-g", "daemon off;"]
