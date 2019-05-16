# STEP 1 build directory / file layout

FROM ubuntu:latest as layout
RUN groupadd -g 1000 appuser
RUN useradd -r -u 1000 -g appuser appuser

RUN mkdir -p /app/data && chmod -R 755 /app


# STEP 2 debug if needed
FROM busybox:latest as builder


# STEP 3 build a small, non-root runtime image
FROM scratch

COPY --from=layout /etc/passwd /etc/passwd
COPY --from=layout /etc/group /etc/group
COPY --chown=appuser:appuser --from=layout /app/data /app/data

# For debug
COPY --from=builder /bin/busybox /bin/busybox
COPY --from=builder /bin/sh /bin/sh

WORKDIR /app
USER appuser


# STEP 4 add application
ADD hello-go /app/hello-go

EXPOSE 8080

CMD ["/app/hello-go"]

