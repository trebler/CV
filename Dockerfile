FROM alpine:3.12.3 as latex

RUN apk add --no-cache \
    texlive-luatex \
    texmf-dist-fontsextra \
    texmf-dist-latexextra

FROM latex as compile

WORKDIR /cv

COPY cv.tex *.png ./

RUN lualatex cv.tex \
    && lualatex cv.tex

FROM alpine:3.12.3 as final

COPY --from=compile /cv/cv.pdf /
