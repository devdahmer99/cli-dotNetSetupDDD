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
mkdir "%PROJECT_DIR%\%PROJECT_NAME%"
cd /d "%PROJECT_DIR%\%PROJECT_NAME%"

:: Criando a solução do projeto dentro do diretório correto
dotnet new sln -n %PROJECT_NAME%

:: Criando a pasta src para os projetos
mkdir src

:: Criando os projetos dentro do diretório src:
dotnet new webapi -n %PROJECT_NAME%.API --use-controllers -o src\%PROJECT_NAME%.API
dotnet new classlib -n %PROJECT_NAME%.Aplicacao -o src\%PROJECT_NAME%.Aplicacao
dotnet new classlib -n %PROJECT_NAME%.Dominio -o src\%PROJECT_NAME%.Dominio
dotnet new classlib -n %PROJECT_NAME%.Infra -o src\%PROJECT_NAME%.Infra
dotnet new classlib -n %PROJECT_NAME%.Comunicacao -o src\%PROJECT_NAME%.Comunicacao
dotnet new classlib -n %PROJECT_NAME%.Exception -o src\%PROJECT_NAME%.Exception

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
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Aplicacao\%PROJECT_NAME%.Aplicacao.csproj
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Dominio\%PROJECT_NAME%.Dominio.csproj
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Comunicacao\%PROJECT_NAME%.Comunicacao.csproj
dotnet sln %PROJECT_NAME%.sln add src\%PROJECT_NAME%.Exception\%PROJECT_NAME%.Exception.csproj

:: Adicionando as referências entre cada projeto:
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj reference src\%PROJECT_NAME%.Aplicacao\%PROJECT_NAME%.Aplicacao.csproj
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj reference src\%PROJECT_NAME%.Comunicacao\%PROJECT_NAME%.Comunicacao.csproj
dotnet add src\%PROJECT_NAME%.API\%PROJECT_NAME%.API.csproj reference src\%PROJECT_NAME%.Exception\%PROJECT_NAME%.Exception.csproj
dotnet add src\%PROJECT_NAME%.Aplicacao\%PROJECT_NAME%.Aplicacao.csproj reference src\%PROJECT_NAME%.Dominio\%PROJECT_NAME%.Dominio.csproj
dotnet add src\%PROJECT_NAME%.Aplicacao\%PROJECT_NAME%.Aplicacao.csproj reference src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj
dotnet add src\%PROJECT_NAME%.Infra\%PROJECT_NAME%.Infra.csproj reference src\%PROJECT_NAME%.Dominio\%PROJECT_NAME%.Dominio.csproj
dotnet add src\%PROJECT_NAME%.Dominio\%PROJECT_NAME%.Dominio.csproj reference src\%PROJECT_NAME%.Comunicacao\%PROJECT_NAME%.Comunicacao.csproj

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
echo Este projeto segue o padrão DDD com as seguintes camadas: Aplicacao, Dominio, Infra, Comunicacao e Exception.>> README.md

:: Criando o arquivo .gitignore
echo bin/> .gitignore
echo obj/>> .gitignore
echo .vs/>> .gitignore
echo **/*.user>> .gitignore
echo **/*.lock.json>> .gitignore

:: Inicializando o repositório Git
git init
git add .
git commit -m "Initial commit"

:: Criando a entidade Usuario no projeto Dominio
echo using System.ComponentModel.DataAnnotations;> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo namespace %PROJECT_NAME%.Dominio.Entidades {>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo     public class Usuario {>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo         [Key]>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo         public int Id { get; set; }>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo         [Required]>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo         public string Nome { get; set; }>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo         [Required]>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo         [EmailAddress]>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo         public string Email { get; set; }>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo         [Required]>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo         public string Senha { get; set; }>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo     }>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs
echo }>> src\%PROJECT_NAME%.Dominio\Entidades\Usuario.cs

:: Configurando o AppDbContext no projeto Infra
echo using Microsoft.EntityFrameworkCore;> src\%PROJECT_NAME%.Infra\DataAccess\AppDbContext.cs
echo using %PROJECT_NAME%.Dominio.Entidades;>> src\%PROJECT_NAME%.Infra\DataAccess\AppDbContext.cs
echo namespace %PROJECT_NAME%.Infra.DataAccess {>> src\%PROJECT_NAME%.Infra\DataAccess\AppDbContext.cs
echo     public class AppDbContext : DbContext {>> src\%PROJECT_NAME%.Infra\DataAccess\AppDbContext.cs
echo         public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }>> src\%PROJECT_NAME%.Infra\DataAccess\AppDbContext.cs
echo         public DbSet<Usuario> Usuarios { get; set; }>> src\%PROJECT_NAME%.Infra\DataAccess\AppDbContext.cs
echo     }>> src\%PROJECT_NAME%.Infra\DataAccess\AppDbContext.cs
echo }>> src\%PROJECT_NAME%.Infra\DataAccess\AppDbContext.cs

:: Criando o repositório no projeto Infra
echo using System.Threading.Tasks;> src\%PROJECT_NAME%.Infra\DataAccess\IUsuarioRepository.cs
echo using %PROJECT_NAME%.Dominio.Entidades;>> src\%PROJECT_NAME%.Infra\DataAccess\IUsuarioRepository.cs
echo namespace %PROJECT_NAME%.Infra.DataAccess {>> src\%PROJECT_NAME%.Infra\DataAccess\IUsuarioRepository.cs
echo     public interface IUsuarioRepository {>> src\%PROJECT_NAME%.Infra\DataAccess\IUsuarioRepository.cs
echo         Task AdicionarUsuarioAsync(Usuario usuario);>> src\%PROJECT_NAME%.Infra\DataAccess\IUsuarioRepository.cs
echo     }>> src\%PROJECT_NAME%.Infra\DataAccess\IUsuarioRepository.cs
echo }>> src\%PROJECT_NAME%.Infra\DataAccess\IUsuarioRepository.cs

echo using System.Threading.Tasks;> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo using %PROJECT_NAME%.Dominio.Entidades;>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo using Microsoft.EntityFrameworkCore;>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo namespace %PROJECT_NAME%.Infra.DataAccess {>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo     public class UsuarioRepository : IUsuarioRepository {>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo         private readonly AppDbContext _context;>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo         public UsuarioRepository(AppDbContext context) {>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo             _context = context;>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo         }>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo         public async Task AdicionarUsuarioAsync(Usuario usuario) {>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo             await _context.Usuarios.AddAsync(usuario);>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo             await _context.SaveChangesAsync();>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo         }>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo     }>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs
echo }>> src\%PROJECT_NAME%.Infra\DataAccess\UsuarioRepository.cs

:: Configurando o AutoMapper no projeto Aplicacao
echo using AutoMapper;> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo using %PROJECT_NAME%.Dominio.Entidades;>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo using %PROJECT_NAME%.Comunicacao.Requests;>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo using %PROJECT_NAME%.Comunicacao.Responses;>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo namespace %PROJECT_NAME%.Aplicacao.AutoMapper {>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo     public class UsuarioProfile : Profile {>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo         public UsuarioProfile() {>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo             CreateMap<Usuario, UsuarioResponse>();>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo             CreateMap<UsuarioRequest, Usuario>();>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo         }>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo     }>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs
echo }>> src\%PROJECT_NAME%.Aplicacao\AutoMapper\UsuarioProfile.cs

:: Criando o UseCase no projeto Aplicacao
echo using System.Threading.Tasks;> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo using %PROJECT_NAME%.Dominio.Entidades;>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo using %PROJECT_NAME%.Infra.DataAccess;>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo namespace %PROJECT_NAME%.Aplicacao.UseCase {>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo     public class AdicionarUsuarioUseCase {>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo         private readonly IUsuarioRepository _usuarioRepository;>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo         public AdicionarUsuarioUseCase(IUsuarioRepository usuarioRepository) {>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo             _usuarioRepository = usuarioRepository;>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo         }>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo         public async Task Execute(Usuario usuario) {>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo             await _usuarioRepository.AdicionarUsuarioAsync(usuario);>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo         }>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo     }>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs
echo }>> src\%PROJECT_NAME%.Aplicacao\UseCase\AdicionarUsuarioUseCase.cs

:: Configurando o Program.cs no projeto API para usar o MySQL com a referência do AppDbContext
echo using Microsoft.EntityFrameworkCore;> src\%PROJECT_NAME%.API\Program.cs
echo using %PROJECT_NAME%.Infra.DataAccess;>> src\%PROJECT_NAME%.API\Program.cs
echo using %PROJECT_NAME%.Aplicacao.UseCase;>> src\%PROJECT_NAME%.API\Program.cs
echo using AutoMapper;>> src\%PROJECT_NAME%.API\Program.cs
echo var builder = WebApplication.CreateBuilder(args);>> src\%PROJECT_NAME%.API\Program.cs
echo var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");>> src\%PROJECT_NAME%.API\Program.cs
echo builder.Services.AddDbContext<AppDbContext>(options =>>> src\%PROJECT_NAME%.API\Program.cs
echo     options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString)));>> src\%PROJECT_NAME%.API\Program.cs
echo builder.Services.AddScoped<IUsuarioRepository, UsuarioRepository>();>> src\%PROJECT_NAME%.API\Program.cs
echo builder.Services.AddScoped<AdicionarUsuarioUseCase>();>> src\%PROJECT_NAME%.API\Program.cs
echo builder.Services.AddAutoMapper(typeof(Program));>> src\%PROJECT_NAME%.API\Program.cs
echo builder.Services.AddControllers();>> src\%PROJECT_NAME%.API\Program.cs
echo var app = builder.Build();>> src\%PROJECT_NAME%.API\Program.cs
echo if (app.Environment.IsDevelopment()) { app.UseDeveloperExceptionPage(); }>> src\%PROJECT_NAME%.API\Program.cs
echo app.UseHttpsRedirection();>> src\%PROJECT_NAME%.API\Program.cs
echo app.UseAuthorization();>> src\%PROJECT_NAME%.API\Program.cs
echo app.MapControllers();>> src\%PROJECT_NAME%.API\Program.cs
echo app.Run();>> src\%PROJECT_NAME%.API\Program.cs

:: Criando o controller no projeto API
echo using Microsoft.AspNetCore.Mvc;> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo using %PROJECT_NAME%.Aplicacao.UseCase;>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo using %PROJECT_NAME%.Comunicacao.Requests;>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo using %PROJECT_NAME%.Comunicacao.Responses;>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo using AutoMapper;>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo namespace %PROJECT_NAME%.API.Controllers {>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo     [ApiController]>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo     [Route("api/[controller]")]>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo     public class UsuarioController : ControllerBase {>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo         private readonly AdicionarUsuarioUseCase _useCase;>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo         private readonly IMapper _mapper;>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo         public UsuarioController(AdicionarUsuarioUseCase useCase, IMapper mapper) {>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo             _useCase = useCase;>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo             _mapper = mapper;>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo         }>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo         [HttpPost]>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo         public async Task<ActionResult<UsuarioResponse>> Post(UsuarioRequest request) {>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo             var usuario = _mapper.Map<Usuario>(request);>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo             await _useCase.Execute(usuario);>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo             var response = _mapper.Map<UsuarioResponse>(usuario);>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo             return CreatedAtAction(nameof(Post), new { id = usuario.Id }, response);>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo         }>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo     }>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs
echo }>> src\%PROJECT_NAME%.API\Controllers\UsuarioController.cs

:: Criando a classe de Request no projeto Comunicacao
echo namespace %PROJECT_NAME%.Comunicacao.Requests {> src\%PROJECT_NAME%.Comunicacao\Requests\UsuarioRequest.cs
echo     public class UsuarioRequest {>> src\%PROJECT_NAME%.Comunicacao\Requests\UsuarioRequest.cs
echo         public string Nome { get; set; }>> src\%PROJECT_NAME%.Comunicacao\Requests\UsuarioRequest.cs
echo         public string Email { get; set; }>> src\%PROJECT_NAME%.Comunicacao\Requests\UsuarioRequest.cs
echo         public string Senha { get; set; }>> src\%PROJECT_NAME%.Comunicacao\Requests\UsuarioRequest.cs
echo     }>> src\%PROJECT_NAME%.Comunicacao\Requests\UsuarioRequest.cs
echo }>> src\%PROJECT_NAME%.Comunicacao\Requests\UsuarioRequest.cs

:: Criando a classe de Response no projeto Comunicacao
echo namespace %PROJECT_NAME%.Comunicacao.Responses {> src\%PROJECT_NAME%.Comunicacao\Responses\UsuarioResponse.cs
echo     public class UsuarioResponse {>> src\%PROJECT_NAME%.Comunicacao\Responses\UsuarioResponse.cs
echo         public int Id { get; set; }>> src\%PROJECT_NAME%.Comunicacao\Responses\UsuarioResponse.cs
echo         public string Nome { get; set; }>> src\%PROJECT_NAME%.Comunicacao\Responses\UsuarioResponse.cs
echo         public string Email { get; set; }>> src\%PROJECT_NAME%.Comunicacao\Responses\UsuarioResponse.cs
echo     }>> src\%PROJECT_NAME%.Comunicacao\Responses\UsuarioResponse.cs
echo }>> src\%PROJECT_NAME%.Comunicacao\Responses\UsuarioResponse.cs

:: Criando as classes de injecao de dependencia no projeto Aplicacao
echo using Microsoft.Extensions.DependencyInjection;> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs
echo using %PROJECT_NAME%.Aplicacao.UseCase;>> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs
echo namespace %PROJECT_NAME%.Aplicacao {>> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs
echo     public static class DependencyInjection {>> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs
echo         public static IServiceCollection AddApplicationServices(this IServiceCollection services) {>> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs
echo             services.AddScoped<AdicionarUsuarioUseCase>();>> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs
echo             return services;>> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs
echo         }>> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs
echo     }>> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs
echo }>> src\%PROJECT_NAME%.Aplicacao\DependencyInjection.cs

:: Criando as classes de injecao de dependencia no projeto Infra
echo using Microsoft.Extensions.DependencyInjection;> src\%PROJECT_NAME%.Infra\DependencyInjection.cs
echo using %PROJECT_NAME%.Infra.DataAccess;>> src\%PROJECT_NAME%.Infra\DependencyInjection.cs
echo namespace %PROJECT_NAME%.Infra {>> src\%PROJECT_NAME%.Infra\DependencyInjection.cs
echo     public static class DependencyInjection {>> src\%PROJECT_NAME%.Infra\DependencyInjection.cs
echo         public static IServiceCollection AddInfrastructureServices(this IServiceCollection services) {>> src\%PROJECT_NAME%.Infra\DependencyInjection.cs
echo             services.AddScoped<IUsuarioRepository, UsuarioRepository>();>> src\%PROJECT_NAME%.Infra\DependencyInjection.cs
echo             return services;>> src\%PROJECT_NAME%.Infra\DependencyInjection.cs
echo         }>> src\%PROJECT_NAME%.Infra\DependencyInjection.cs
echo     }>> src\%PROJECT_NAME%.Infra\DependencyInjection.cs
echo }>> src\%PROJECT_NAME%.Infra\DependencyInjection.cs

:: Modificando o Program.cs para incluir os serviços de Aplicacao e Infra
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
) > src\%PROJECT_NAME%.API\Program.cs

:: Configurando a autenticação JWT no projeto Infra
echo using Microsoft.IdentityModel.Tokens;> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo using System;>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo using System.IdentityModel.Tokens.Jwt;>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo using System.Security.Claims;>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo using System.Text;>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo namespace %PROJECT_NAME%.Infra.Seguranca {>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo     public class JwtService {>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo         private readonly string _secret;>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo         private readonly string _expDate;>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo         public JwtService(string secret, string expDate) {>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo             _secret = secret;>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo             _expDate = expDate;>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo         }>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo         public string GenerateSecurityToken(string email) {>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo             var tokenHandler = new JwtSecurityTokenHandler();>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo             var key = Encoding.ASCII.GetBytes(_secret);>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo             var tokenDescriptor = new SecurityTokenDescriptor {>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo                 Subject = new ClaimsIdentity(new[] { new Claim(ClaimTypes.Email, email) }),>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo                 Expires = DateTime.UtcNow.AddMinutes(double.Parse(_expDate)),>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo                 SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo             };>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo             var token = tokenHandler.CreateToken(tokenDescriptor);>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo             return tokenHandler.WriteToken(token);>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo         }>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo     }>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs
echo }>> src\%PROJECT_NAME%.Infra\Seguranca\JwtService.cs

:: Configurando o appsettings.json com a conexão do banco de dados MySQL e configuração JWT
echo {> src\%PROJECT_NAME%.API\appsettings.json
echo   "ConnectionStrings": {>> src\%PROJECT_NAME%.API\appsettings.json
echo     "DefaultConnection": "Server=localhost;Database=%PROJECT_NAME%;User=%DB_USER%;Password=%DB_PASSWORD%;">> src\%PROJECT_NAME%.API\appsettings.json
echo   },>> src\%PROJECT_NAME%.API\appsettings.json
echo   "Jwt": {>> src\%PROJECT_NAME%.API\appsettings.json
echo     "SecretKey": "YourSecretKey",>> src\%PROJECT_NAME%.API\appsettings.json
echo     "ExpiryMinutes": "60">> src\%PROJECT_NAME%.API\appsettings.json
echo   },>> src\%PROJECT_NAME%.API\appsettings.json
echo   "Logging": {>> src\%PROJECT_NAME%.API\appsettings.json
echo     "LogLevel": {>> src\%PROJECT_NAME%.API\appsettings.json
echo       "Default": "Information",>> src\%PROJECT_NAME%.API\appsettings.json
echo       "Microsoft.AspNetCore": "Warning">> src\%PROJECT_NAME%.API\appsettings.json
echo     }>> src\%PROJECT_NAME%.API\appsettings.json
echo   },>> src\%PROJECT_NAME%.API\appsettings.json
echo   "AllowedHosts": "*" >> src\%PROJECT_NAME%.API\appsettings.json
echo }>> src\%PROJECT_NAME%.API\appsettings.json

:: Rodar a migration inicial
cd /d "%PROJECT_DIR%\%PROJECT_NAME%"
dotnet ef migrations add CriaTabelaUsuario --project src\%PROJECT_NAME%.Infra --startup-project src\%PROJECT_NAME%.API
dotnet ef database update --project src\%PROJECT_NAME%.Infra --startup-project src\%PROJECT_NAME%.API

:: Voltando para o diretório do projeto
cd /d "%PROJECT_DIR%\%PROJECT_NAME%"

:: Restaurando os pacotes (ignorando feeds com erro)
dotnet restore --ignore-failed-sources --disable-parallel

echo Estrutura do projeto criada com sucesso em: %PROJECT_DIR%\%PROJECT_NAME%
pause
