FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS ontology

WORKDIR /renewx

# 修复：将 apt 源指向 Debian 归档服务器，因为 Debian 10 已停止维护
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
    && sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list \
    && sed -i '/buster-updates/d' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends unzip

COPY Microsoft365_E5_Renew_X.zip /renewx/Microsoft365_E5_Renew_X.zip

RUN unzip Microsoft365_E5_Renew_X.zip -d /renewx \
    && rm -rf Microsoft365_E5_Renew_X.zip

FROM mcr.microsoft.com/dotnet/aspnet:3.1

LABEL MAINTAINER="Gladtbam"

ENV LANG=zh_CN.UTF-8 \
    TZ=Asia/Shanghai

WORKDIR /renewx

EXPOSE 1066

COPY --from=ontology /renewx /renewx

ENTRYPOINT ["dotnet", "Microsoft365_E5_Renew_X.dll"]
