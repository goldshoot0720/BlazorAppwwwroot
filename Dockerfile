# ---- Build Stage ----
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# �ƻs csproj ���٭� NuGet �M��
COPY ["BlazorApp1/BlazorApp1.csproj", "BlazorApp1/"]
RUN dotnet restore "BlazorApp1/BlazorApp1.csproj"

# �ƻs�M���ɮרëظm
COPY . .
WORKDIR /src/BlazorApp1
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# ---- Runtime Stage ----
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# �]�w�����ܼƻP���S�ݤf
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# �Ұ�����
ENTRYPOINT ["dotnet", "BlazorApp1.dll"]
