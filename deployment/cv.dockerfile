# Final stage
FROM nginx:1.22.0-alpine as final

COPY gihub-pages/cv.pdf /usr/share/nginx/html

COPY deployment/nginx.conf /etc/nginx/conf.d/default.conf