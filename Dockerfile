FROM alpine:3.17.2 as latex

RUN apk add --no-cache \
    texlive-luatex \
    texmf-dist-fontsextra \
    texmf-dist-latexextra

FROM latex as compile

WORKDIR /cv

COPY cv.tex photo.png ./

ARG VERSION=0.0.0

ENV \
    TEXMFCACHE=/root/.cache \
    TEXMVAR=/root/.cache \
    VERSION=${VERSION}

RUN --mount=type=cache,target=/root/.cache \
    lualatex cv.tex \
    && lualatex cv.tex

FROM alpine:3.17.2 as final

WORKDIR /cv

COPY --from=compile /cv/cv.pdf .

CMD [ "cat", "cv.pdf" ]
