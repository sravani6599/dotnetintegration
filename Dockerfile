#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /wwwroot
COPY ["WebApplication1.csproj", "wwwroot"]
RUN dotnet restore "WebApplication1.csproj"
COPY . .
WORKDIR "/wwwroot"
RUN dotnet build WebApplication1.csproj -c Debug -o /app

FROM build as debug
RUN dotnet publish "WebApplication1.csproj" -c Debug -o /app

FROM base as final
WORKDIR /app
COPY --from=publish/app /app .
ENTRYPOINT ["dotnet","App.Web.dll"]
