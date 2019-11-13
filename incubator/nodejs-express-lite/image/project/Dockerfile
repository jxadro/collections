# Dockerfile for building your application.
# Defines the final image that contains content from both the image and template.

FROM jxadro/nodebase:1.2

COPY . /project
WORKDIR /project/user-app


EXPOSE 8080

# Pass control your application
CMD ["npm",  "start"]
