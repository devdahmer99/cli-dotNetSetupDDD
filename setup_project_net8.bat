@echo off
setlocal enabledelayedexpansion

:: Solicita o nome do projeto ao usuário
set /p PROJECT_NAME=Digite o nome do projeto: 

:: Solicita o nome de usuário do banco de dados
set /p DB_USER=Digite o nome de usuario do banco de dados: 

:: Solicita a senha do banco de dados
set /p DB_PASSWORD=Digite a senha do banco de dados: 

:: Verifica se foi passado um argumento (pasta de destino)
if "%~1"=="" (
    echo Uso: setup_project.bat "C:\caminho\para\projeto"
    exit /b 1
)

set PROJECT_DIR=%~1

:: Criando a pasta do projeto no diretório especificado
mkdir "%PROJECT_DIR%\%PROJECT_NAME%" || exit /b 1
cd /d "%PROJECT_DIR%\%PROJECT_NAME%" || exit /b 1

:: Criando a solução do projeto dentro do diretório correto
dotnet new sln -n %PROJECT_NAME% || exit /b 1

:: Criando a pasta src para os projetos
mkdir src || exit /b 1

:: Criando os projetos dentro do diretório src:
dotnet new webapi -n %PROJECT_NAME%.API --use-controllers -o src\%PROJECT_NAME%.API || exit /b 1
dotnet new classlib -n %PROJECT_NAME%.Aplicacao -o src\%PROJECT_NAME%.Aplicacao || exit /b 1
dotnet new classlib -n %PROJECT_NAME%.Dominio -o src\%PROJECT_NAME%.Dominio || exit /b 1
dotnet new classlib -n %PROJECT_NAME%.Infra -o src\%PROJECT_NAME%.Infra || exit /b 1
dotnet new classlib -n %PROJECT_NAME%.Comunicacao -o src\%PROJECT_NAME%.Comunicacao || exit /b 1
dotnet new classlib -n %PROJECT_NAME%.Exception -o src\%PROJECT_NAME%.Exception || exit /b 1

:: Criando a estrutura de pastas para cada projeto
mkdir src\%PROJECT_NAME%.Aplicacao\AutoMapper
mkdir src\%PROJECT_NAME%.Aplicacao\Enums
mkdir src\%PROJECT_NAME%.Aplicacao\Reports
mkdir src\%PROJECT_NAME%.Aplicacao\UseCase

mkdir src\%PROJECT_NAME%.Dominio\Entidades
mkdir src\%PROJECT_NAME%.Dominio\Enums
mkdir src\%PROJECT_NAME%.Dominio\Extensoes
mkdir src\%PROJECT_NAME%.Dominio\Reports
mkdir src\%PROJECT_NAME%.Dominio\Repositories
mkdir src\%PROJECT_NAME%.Dominio\Seguranca
mkdir src\%PROJECT_NAME%.Dominio\Services

mkdir src\%PROJECT_NAME%.Infra\DataAccess
mkdir src\%PROJECT_NAME%.Infra\Extensoes
mkdir src\%PROJECT_NAME%.Infra\Migrations
mkdir src\%PROJECT_NAME%.Infra\Seguranca
mkdir src\%PROJECT_NAME%.Infra\Services

mkdir src\%PROJECT_NAME%.Comunicacao\Enums
mkdir src\%PROJECT_NAME%.Comunicacao\Requests
mkdir src\%PROJECT_NAME%.Comunicacao\Responses

mkdir src\%PROJECT_NAME%.Exception\ExceptionBase

:: Mudando para o diretório da solução para evitar problemas
cd /d "%PROJECT_DIR%\%PROJECT_NAME%"

:: Adicionando os projetos na solução
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj || exit /b 1
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Aplicacao\%PROJECT_NAME%.Aplicacao.csproj || exit /b 1
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Dominio\%PROJECT_NAME%.Dominio.csproj || exit /b 1
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj || exit /b 1
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Comunicacao\%PROJECT_NAME%.Comunicacao.csproj || exit /b 1
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Exception\%PROJECT_NAME%.Exception.csproj || exit /b 1

:: Adicionando as referências entre cada projeto:
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj reference src\%PROJECT_NAME%.Aplicacao\%PROJECT_NAME%.Aplicacao.csproj || exit /b 1
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj reference src\%PROJECT_NAME%.Comunicacao\%PROJECT_NAME%.Comunicacao.csproj || exit /b 1
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj reference src\%PROJECT_NAME%.Exception\%PROJECT_NAME%.Exception.csproj || exit /b 1
dotnet add src\%PROJECT_NAME%.Aplicacao\%PROJECT_NAME%.Aplicacao.csproj reference src\%PROJECT_NAME%.Dominio\%PROJECT_NAME%.Dominio.csproj || exit /b 1
dotnet add src\%PROJECT_NAME%.Aplicacao\%PROJECT_NAME%.Aplicacao.csproj reference src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj || exit /b 1
dotnet add src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj reference src\%PROJECT_NAME%.Dominio\%PROJECT_NAME%.Dominio.csproj || exit /b 1
dotnet add src\%PROJECT_NAME%.Dominio\%PROJECT_NAME%.Dominio.csproj reference src\%PROJECT_NAME%.Comunicacao\%PROJECT_NAME%.Comunicacao.csproj || exit /b 1

:: Instalando os pacotes necessários
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj package AutoMapper.Extensions.Microsoft.DependencyInjection --version 12.0.0
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj package Microsoft.EntityFrameworkCore.Design --version 8.0.0
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj package Microsoft.EntityFrameworkCore.Tools --version 8.0.0
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj package Microsoft.AspNetCore.Authentication.JwtBearer --version 8.0.0
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj package Pomelo.EntityFrameworkCore.MySql --version 8.0.0
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj package FluentValidation --version 11.7.1
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj package Microsoft.Extensions.DependencyInjection.Abstractions --version 8.0.0
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj package Microsoft.Extensions.Options --version 8.0.0
dotnet add src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj package Microsoft.EntityFrameworkCore.Design --version 8.0.0
dotnet add src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj package Microsoft.EntityFrameworkCore.Tools --version 8.0.0
dotnet add src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj package Pomelo.EntityFrameworkCore.MySql --version 8.0.0
dotnet add src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj package Microsoft.AspNetCore.Authentication.JwtBearer --version 8.0.0

:: Criando o arquivo README.md
echo # %PROJECT_NAME%> README.md
echo Este projeto segue o padrão DDD com as seguintes camadas: Aplicacao, Dominio, Infra, Comunicacao e Exception.>> README.md || exit /b 1

:: Criando o arquivo .gitignore
echo bin/> .gitignore || exit /b 1
echo obj/>> .gitignore
echo .vs/>> .gitignore
echo **/*.user>> .gitignore
echo **/*.lock.json>> .gitignore

:: Inicializando o repositório Git
git init
git add .
git commit -m "Initial commit"

:: Criando a entidade Usuario no projeto Dominio
echo Criando a entidade Usuario no projeto Dominio
(
    echo using System.ComponentModel.DataAnnotations;
    echo namespace %PROJECT_NAME%.Dominio.Entidades {
    echo     public class Usuario {
    echo         [Key]
    echo         public int Id { get; set; }
    echo         [Required]
    echo         public string Nome { get; set; }
    echo         [Required]
    echo         [EmailAddress]
    echo         public string Email { get; set; }
    echo         [Required]
    echo         public string Senha { get; set; }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao criar a entidade Usuario no projeto Dominio
    exit /b 1
)

:: Configurando o AppDbContext no projeto Infra
echo Configurando o AppDbContext no projeto Infra
(
    echo using Microsoft.EntityFrameworkCore;
    echo using %PROJECT_NAME%.Dominio.Entidades;
    echo namespace %PROJECT_NAME%.Infra.DataAccess {
    echo     public class AppDbContext : DbContext {
    echo         public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
    echo         public DbSet<Usuario> Usuarios { get; set; }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Infra\DataAccess\AppDbContext.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao configurar o AppDbContext no projeto Infra
    exit /b 1
)

:: Criando o repositório no projeto Infra
echo Criando o repositório no projeto Infra
(
    echo using System.Threading.Tasks;
    echo using %PROJECT_NAME%.Dominio.Entidades;
    echo namespace %PROJECT_NAME%.Infra.DataAccess {
    echo     public interface IUsuarioRepository {
    echo         Task AdicionarUsuarioAsync(Usuario usuario);
    echo     }
    echo }
) > src\%PROJECT_NAME%.Infra\DataAccess\IUsuarioRepository.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao criar o repositório no projeto Infra
    exit /b 1
)

(
    echo using System.Threading.Tasks;
    echo using %PROJECT_NAME%.Dominio.Entidades;
    echo using Microsoft.EntityFrameworkCore;
    echo namespace %PROJECT_NAME%.Infra.DataAccess {
    echo     public class UsuarioRepository : IUsuarioRepository {
    echo         private readonly AppDbContext _context;
    echo         public UsuarioRepository(AppDbContext context) {
    echo             _context = context;
    echo         }
    echo         public async Task AdicionarUsuarioAsync(Usuario usuario) {
    echo             await _context.Usuarios.AddAsync(usuario);
    echo             await _context.SaveChangesAsync();
    echo         }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao criar o repositório Usuario no projeto Infra
    exit /b 1
)

:: Configurando o AutoMapper no projeto Aplicacao
echo Configurando o AutoMapper no projeto Aplicacao
(
    echo using AutoMapper;
    echo using %PROJECT_NAME%.Dominio.Entidades;
    echo using %PROJECT_NAME%.Comunicacao.Requests;
    echo using %PROJECT_NAME%.Comunicacao.Responses;
    echo namespace %PROJECT_NAME%.Aplicacao.AutoMapper {
    echo     public class UsuarioProfile : Profile {
    echo         public UsuarioProfile() {
    echo             CreateMap<Usuario, UsuarioResponse>();
    echo             CreateMap<UsuarioRequest, Usuario>();
    echo         }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao configurar o AutoMapper no projeto Aplicacao
    exit /b 1
)

:: Criando o UseCase no projeto Aplicacao
echo Criando o UseCase no projeto Aplicacao
(
    echo using System.Threading.Tasks;
    echo using %PROJECT_NAME%.Dominio.Entidades;
    echo using %PROJECT_NAME%.Infra.DataAccess;
    echo namespace %PROJECT_NAME%.Aplicacao.UseCase {
    echo     public class AdicionarUsuarioUseCase {
    echo         private readonly IUsuarioRepository _usuarioRepository;
    echo         public AdicionarUsuarioUseCase(IUsuarioRepository usuarioRepository) {
    echo             _usuarioRepository = usuarioRepository;
    echo         }
    echo         public async Task Execute(Usuario usuario) {
    echo             await _usuarioRepository.AdicionarUsuarioAsync(usuario);
    echo         }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao criar o UseCase no projeto Aplicacao
    exit /b 1
)

:: Configurando o Program.cs no projeto API para usar o MySQL com a referência do AppDbContext
echo Configurando o Program.cs no projeto API para usar o MySQL
(
    echo using Microsoft.EntityFrameworkCore;
    echo using %PROJECT_NAME%.Infra.DataAccess;
    echo using %PROJECT_NAME%.Aplicacao.UseCase;
    echo using AutoMapper;
    echo var builder = WebApplication.CreateBuilder(args);
    echo var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
    echo builder.Services.AddDbContext<AppDbContext>(options => options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString)));
    echo builder.Services.AddScoped<IUsuarioRepository, UsuarioRepository>();
    echo builder.Services.AddScoped<AdicionarUsuarioUseCase>();
    echo builder.Services.AddAutoMapper(typeof(Program));
    echo builder.Services.AddControllers();
    echo var app = builder.Build();
    echo if (app.Environment.IsDevelopment()) { app.UseDeveloperExceptionPage(); }
    echo app.UseHttpsRedirection();
    echo app.UseAuthorization();
    echo app.MapControllers();
    echo app.Run();
) > src\%PROJECT_NAME%.API\Program.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao configurar o Program.cs no projeto API
    exit /b 1
)

:: Criando o controller no projeto API
echo Criando o controller no projeto API
(
    echo using Microsoft.AspNetCore.Mvc;
    echo using %PROJECT_NAME%.Aplicacao.UseCase;
    echo using %PROJECT_NAME%.Comunicacao.Requests;
    echo using %PROJECT_NAME%.Comunicacao.Responses;
    echo using AutoMapper;
    echo namespace %PROJECT_NAME%.API.Controllers {
    echo     [ApiController]
    echo     [Route("api/[controller]")]
    echo     public class UsuarioController : ControllerBase {
    echo         private readonly AdicionarUsuarioUseCase _useCase;
    echo         private readonly IMapper _mapper;
    echo         public UsuarioController(AdicionarUsuarioUseCase useCase, IMapper mapper) {
    echo             _useCase = useCase;
    echo             _mapper = mapper;
    echo         }
    echo         [HttpPost]
    echo         public async Task<ActionResult<UsuarioResponse>> Post(UsuarioRequest request) {
    echo             var usuario = _mapper.Map<Usuario>(request);
    echo             await _useCase.Execute(usuario);
    echo             var response = _mapper.Map<UsuarioResponse>(usuario);
    echo             return CreatedAtAction(nameof(Post), new { id = usuario.Id }, response);
    echo         }
    echo     }
    echo }
) > src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao criar o controller no projeto API
    exit /b 1
)

:: Criando a classe de Request no projeto Comunicacao
echo Criando a classe de Request no projeto Comunicacao
(
    echo namespace %PROJECT_NAME%.Comunicacao.Requests {
    echo     public class UsuarioRequest {
    echo         public string Nome { get; set; }
    echo         public string Email { get; set; }
    echo         public string Senha { get; set; }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Comunicacao\Requests\UsuarioRequest.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao criar a classe de Request no projeto Comunicacao
    exit /b 1
)

:: Criando a classe de Response no projeto Comunicacao
echo Criando a classe de Response no projeto Comunicacao
(
    echo namespace %PROJECT_NAME%.Comunicacao.Responses {
    echo     public class UsuarioResponse {
    echo         public int Id { get; set; }
    echo         public string Nome { get; set; }
    echo         public string Email { get; set; }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Comunicacao\Responses\UsuarioResponse.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao criar a classe de Response no projeto Comunicacao
    exit /b 1
)

:: Criando as classes de injecao de dependencia no projeto Aplicacao
echo Criando as classes de injecao de dependencia no projeto Aplicacao
(
    echo using Microsoft.Extensions.DependencyInjection;
    echo using %PROJECT_NAME%.Aplicacao.UseCase;
    echo namespace %PROJECT_NAME%.Aplicacao {
    echo     public static class DependencyInjection {
    echo         public static IServiceCollection AddApplicationServices(this IServiceCollection services) {
    echo             services.AddScoped<AdicionarUsuarioUseCase>();
    echo             return services;
    echo         }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao criar as classes de injecao de dependencia no projeto Aplicacao
    exit /b 1
)

:: Criando as classes de injecao de dependencia no projeto Infra
echo Criando as classes de injecao de dependencia no projeto Infra
(
    echo using Microsoft.Extensions.DependencyInjection;
    echo using %PROJECT_NAME%.Infra.DataAccess;
    echo namespace %PROJECT_NAME%.Infra {
    echo     public static class DependencyInjection {
    echo         public static IServiceCollection AddInfrastructureServices(this IServiceCollection services) {
    echo             services.AddScoped<IUsuarioRepository, UsuarioRepository>();
    echo             return services;
    echo         }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Infra\DependencyInjection.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao criar as classes de injecao de dependencia no projeto Infra
    exit /b 1
)

:: Modificando o Program.cs para incluir os serviços de Aplicacao e Infra
echo Modificando o Program.cs para incluir os serviços de Aplicacao e Infra
(
    echo using Microsoft.EntityFrameworkCore;
    echo using %PROJECT_NAME%.Infra.DataAccess;
    echo using %PROJECT_NAME%.Aplicacao;
    echo using %PROJECT_NAME%.Infra;
    echo using AutoMapper;
    echo var builder = WebApplication.CreateBuilder(args);
    echo var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
    echo builder.Services.AddDbContext<AppDbContext>(options => options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString)));
    echo builder.Services.AddApplicationServices();
    echo builder.Services.AddInfrastructureServices();
    echo builder.Services.AddAutoMapper(typeof(Program));
    echo builder.Services.AddControllers();
    echo var app = builder.Build();
    echo if (app.Environment.IsDevelopment()) { app.UseDeveloperExceptionPage(); }
    echo app.UseHttpsRedirection();
    echo app.UseAuthorization();
    echo app.MapControllers();
    echo app.Run();
) > src\%PROJECT_NAME%.API\Program.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao modificar o Program.cs para incluir os serviços de Aplicacao e Infra
    exit /b 1
)

:: Configurando a autenticação JWT no projeto Infra
echo Configurando a autenticação JWT no projeto Infra
(
    echo using Microsoft.IdentityModel.Tokens;
    echo using System;
    echo using System.IdentityModel.Tokens.Jwt;
    echo using System.Security.Claims;
    echo using System.Text;
    echo namespace %PROJECT_NAME%.Infra.Seguranca {
    echo     public class JwtService {
    echo         private readonly string _secret;
    echo         private readonly string _expDate;
    echo         public JwtService(string secret, string expDate) {
    echo             _secret = secret;
    echo             _expDate = expDate;
    echo         }
    echo         public string GenerateSecurityToken(string email) {
    echo             var tokenHandler = new JwtSecurityTokenHandler();
    echo             var key = Encoding.ASCII.GetBytes(_secret);
    echo             var tokenDescriptor = new SecurityTokenDescriptor {
    echo                 Subject = new ClaimsIdentity(new[] { new Claim(ClaimTypes.Email, email) }),
    echo                 Expires = DateTime.UtcNow.AddMinutes(double.Parse(_expDate)),
    echo                 SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
    echo             };
    echo             var token = tokenHandler.CreateToken(tokenDescriptor);
    echo             return tokenHandler.WriteToken(token);
    echo         }
    echo     }
    echo }
) > src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs 2>> error.log
if errorlevel 1 (
    echo Erro ao configurar a autenticação JWT no projeto Infra
    exit /b 1
)

:: Configurando o appsettings.json com a conexão do banco de dados MySQL e configuração JWT
echo Configurando o appsettings.json com a conexão do banco de dados MySQL e configuração JWT
(
    echo {
    echo   "ConnectionStrings": {
    echo     "DefaultConnection": "Server=localhost;Database=%PROJECT_NAME%;User=%DB_USER%;Password=%DB_PASSWORD%"
    echo   },
    echo   "Jwt": {
    echo     "SecretKey": "YourSecretKey",
    echo     "ExpiryMinutes": "60"
    echo   },
    echo   "Logging": {
    echo     "LogLevel": {
    echo       "Default": "Information",
    echo       "Microsoft.AspNetCore": "Warning"
    echo     }
    echo   },
    echo   "AllowedHosts": "*"
    echo }
) > src\%PROJECT_NAME%.API\appsettings.json 2>> error.log
if errorlevel 1 (
    echo Erro ao configurar o appsettings.json
    exit /b 1
)

:: Rodar a migration inicial
echo Rodando a migration inicial
cd /d "%PROJECT_DIR%\%PROJECT_NAME%" || exit /b 1
dotnet ef migrations add CriaTabelaUsuario --project src\%PROJECT_NAME%.Infra --startup-project src\%PROJECT_NAME%.API 2>> error.log
if errorlevel 1 (
    echo Erro ao rodar a migration inicial
    exit /b 1
)
dotnet ef database update --project src\%PROJECT_NAME%.Infra --startup-project src\%PROJECT_NAME%.API 2>> error.log
if errorlevel 1 (
    echo Erro ao atualizar o banco de dados
    exit /b 1
)

:: Voltando para o diretório do projeto
echo Voltando para o diretório do projeto
cd /d "%PROJECT_DIR%\%PROJECT_NAME%" || exit /b 1

:: Restaurando os pacotes (ignorando feeds com erro)
echo Restaurando os pacotes (ignorando feeds com erro)
dotnet restore --ignore-failed-sources --disable-parallel 2>> error.log
if errorlevel 1 (
    echo Erro ao restaurar os pacotes
    exit /b 1
)

echo Estrutura do projeto criada com sucesso em: %PROJECT_DIR%\%PROJECT_NAME%
pause
