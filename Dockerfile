# ---- Build Stage ----
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# 複製 csproj 並還原 NuGet 套件
COPY ["BlazorApp1/BlazorApp1.csproj", "BlazorApp1/"]
RUN dotnet restore "BlazorApp1/BlazorApp1.csproj"

# 複製專案檔案並建置
COPY . .
WORKDIR /src/BlazorApp1
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# ---- Runtime Stage ----
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# 設定環境變數與暴露端口
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# 啟動應用
ENTRYPOINT ["dotnet", "BlazorApp1.dll"]
