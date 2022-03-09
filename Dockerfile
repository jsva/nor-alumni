# Build
FROM mcr.microsoft.com/dotnet/core/sdk:5.0-bionic as build
EXPOSE 80
EXPOSE 443
WORKDIR /app

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_16.x |  bash -
RUN apt-get install -y nodejs

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./

RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:5.0-bionic as runtime
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "alumni-api.dll"]