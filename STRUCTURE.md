# GadoTech - Arquitetura Feature-Based

## Visão Geral

Este projeto utiliza **Feature-Based Architecture**, um padrão de organização de código que estrutura a aplicação em torno de funcionalidades específicas do negócio, ao invés de agrupá-las por tipos técnicos (Models, Controllers, etc).

### Por que Feature-Based?

Esta escolha foi baseada em análise de 3 padrões principais:

1. **Standard Laravel**: Simples, mas difícil de escalar com múltiplos domínios
2. **Domain-Driven Design (DDD)**: Escalável, mas complexo para MVP
3. **Feature-Based** (ESCOLHIDO): Equilíbrio perfeito entre simplicidade e escalabilidade

**Benefícios:**
- Cada feature é semi-independente (facilita trabalho em paralelo)
- Fácil navegar entre modelos e código relacionados
- Escalável para 15+ features sem problemas
- Preparado para evoluir para microserviços sem quebra de padrão
- Mantém convenções Laravel padrão

---

## Estrutura de Diretórios

```
app/
├── Features/                    # Funcionalidades principais de negócio
│   ├── Cattle/                 # Gestão de Rebanhos
│   │   ├── Models/             # Eloquent Models da feature
│   │   ├── Controllers/        # Controllers da API/Web
│   │   ├── Services/           # Lógica de negócio complexa
│   │   ├── Repositories/       # Queries reutilizáveis
│   │   ├── Requests/           # Form Requests (validação)
│   │   ├── Resources/          # API Resources (transformação)
│   │   └── database/
│   │       ├── migrations/     # Migrations específicas
│   │       └── factories/      # Factories para seeding/testes
│   │
│   ├── Farm/                   # Gestão de Fazendas
│   ├── Reproduction/           # Gestão de Reprodução
│   ├── HealthMonitoring/       # Monitoramento de Saúde
│   └── Inventory/              # Gestão de Inventário
│
├── Shared/                      # Código reutilizável entre features
│   ├── DTOs/                   # Data Transfer Objects
│   ├── Enums/                  # Enumerações (Status, Types, etc)
│   ├── Traits/                 # Traits reutilizáveis
│   └── Utilities/              # Helper functions e utilitários
│
├── Core/                        # Funcionalidades transversais
│   ├── Auth/                   # Autenticação e autorização
│   ├── Notifications/          # Sistema de notificações
│   └── Middleware/             # Middleware customizado
│
├── Actions/                     # Ações do Laravel padrão
├── Http/                        # HTTP padrão (Kernel, etc)
├── Models/                      # Modelos globais (se houver)
└── Providers/                   # Service Providers

config/                          # Arquivos de configuração
database/                        # Migrations e factories globais
resources/                       # Views, assets
routes/                          # Rotas da aplicação
storage/                         # Logs, uploads, etc
tests/                           # Testes automatizados
```

---

## Features

Uma **Feature** é um conjunto coheso de funcionalidades relacionadas a um domínio de negócio. Cada feature contém:

### Estrutura Interna de uma Feature

```
Features/{Feature}/
├── Models/                 # Eloquent Models
├── Controllers/            # HTTP Controllers (API/Web)
├── Services/              # Classes de serviço para lógica complexa
├── Repositories/          # Repository pattern para queries
├── Requests/              # Form Requests para validação
├── Resources/             # API Resources (formatação de resposta)
└── database/
    ├── migrations/        # Migrations SQL
    └── factories/         # Model Factories
```

### Exemplo: Feature Cattle (Gado)

**Estrutura de arquivos:**
```
app/Features/Cattle/
├── Models/
│   └── Cattle.php                # Model Eloquent
├── Controllers/
│   └── CattleController.php      # Controller principal
├── Services/
│   └── CattleService.php         # Lógica de negócio
├── Repositories/
│   └── CattleRepository.php      # Queries reutilizáveis
├── Requests/
│   ├── StoreCattleRequest.php    # Validação para criar
│   └── UpdateCattleRequest.php   # Validação para atualizar
├── Resources/
│   └── CattleResource.php        # Formatação JSON
└── database/
    ├── migrations/
    │   └── 2025_12_06_000000_create_cattle_table.php
    └── factories/
        └── CattleFactory.php
```

**Namespace exemplo:**
```php
namespace App\Features\Cattle\Models;
namespace App\Features\Cattle\Controllers;
namespace App\Features\Cattle\Services;
```

### Padrão de Implementação

```php
// app/Features/Cattle/Controllers/CattleController.php
namespace App\Features\Cattle\Controllers;

use App\Features\Cattle\Models\Cattle;
use App\Features\Cattle\Services\CattleService;
use App\Features\Cattle\Requests\StoreCattleRequest;
use App\Features\Cattle\Resources\CattleResource;

class CattleController extends Controller
{
    public function __construct(private CattleService $service) {}

    public function index()
    {
        return CattleResource::collection($this->service->getAllCattle());
    }

    public function store(StoreCattleRequest $request)
    {
        $cattle = $this->service->createCattle($request->validated());
        return new CattleResource($cattle);
    }
}
```

---

## Shared (Código Reutilizável)

Use a pasta `Shared` para código que é utilizado por **múltiplas features**.

### DTOs (Data Transfer Objects)

Objetos para transferência de dados entre camadas (controller → service → model).

```php
// app/Shared/DTOs/CattleDTO.php
namespace App\Shared\DTOs;

class CattleDTO
{
    public function __construct(
        public string $name,
        public string $breed,
        public int $age,
        public string $status
    ) {}
}
```

**Quando usar:** Para dados complexos ou validados que precisam ser passados entre functions.

### Enums

Enumerações para tipos, status e categorias.

```php
// app/Shared/Enums/CattleStatus.php
namespace App\Shared\Enums;

enum CattleStatus: string
{
    case HEALTHY = 'healthy';
    case ILL = 'ill';
    case RECOVERING = 'recovering';
    case DECEASED = 'deceased';
}
```

**Quando usar:** Para valores predefinidos que aparecem em múltiplas features.

### Traits

Características (comportamentos) reutilizáveis.

```php
// app/Shared/Traits/HasTimestamps.php
namespace App\Shared\Traits;

trait HasTimestamps
{
    public function getCreatedAtAttribute()
    {
        return $this->attributes['created_at']?->format('Y-m-d H:i:s');
    }
}
```

**Quando usar:** Para comportamentos comuns (timestamps, slugs, auditing).

### Utilities

Funções auxiliares e helpers.

```php
// app/Shared/Utilities/DateHelper.php
namespace App\Shared\Utilities;

class DateHelper
{
    public static function formatBrazilianDate(\DateTime $date): string
    {
        return $date->format('d/m/Y');
    }
}
```

**Quando usar:** Para lógica reutilizável que não se encaixa em Model ou Service.

---

## Core (Funcionalidades Transversais)

Funcionalidades que cortam transversalmente toda a aplicação.

### Auth

```
Core/Auth/
├── AuthService.php         # Lógica de autenticação
├── Policies/               # Authorization policies
└── Middleware/             # Auth middleware
```

### Notifications

```
Core/Notifications/
├── NotificationService.php
├── Channels/               # Canais (Email, SMS, Push)
└── Templates/              # Templates de notificação
```

### Middleware

```
Core/Middleware/
├── AuthenticateRequest.php
├── ValidateApiToken.php
└── LogRequests.php
```

---

## Convenções de Código

### Nomes de Classes

Use **PascalCase** para nomes de classe:
```php
class CattleController  // ✓ Correto
class cattleController  // ✗ Errado
```

### Nomes de Arquivos

Nomes de arquivos com **PascalCase** para classes:
```
CattleController.php    // ✓ Correto
cattle-controller.php   // ✗ Errado
```

### Nomes de Métodos e Propriedades

Use **camelCase**:
```php
public function getAllCattle()  // ✓ Correto
public function get_all_cattle() // ✗ Errado

private $cattleCount;           // ✓ Correto
private $cattle_count;          // ✗ Errado (em classes PHP)
```

### Nomes de Variáveis de Banco de Dados

Use **snake_case** em migrações:
```php
$table->string('cattle_name');      // ✓ Correto
$table->string('cattleName');       // ✗ Errado
```

### Namespaces PSR-4

Todos os namespaces seguem PSR-4:
```php
namespace App\Features\Cattle\Models;
namespace App\Shared\Enums;
namespace App\Core\Auth;
```

---

## Criando uma Nova Feature

### Passo 1: Criar Estrutura de Pastas

```bash
mkdir -p app/Features/VaccineManagement/{Models,Controllers,Services,Repositories,Requests,Resources,database/{migrations,factories}}
```

### Passo 2: Criar Model

```php
// app/Features/VaccineManagement/Models/Vaccine.php
namespace App\Features\VaccineManagement\Models;

use Illuminate\Database\Eloquent\Model;

class Vaccine extends Model
{
    protected $fillable = ['name', 'description', 'dosage'];
}
```

### Passo 3: Criar Controller

```php
// app/Features/VaccineManagement/Controllers/VaccineController.php
namespace App\Features\VaccineManagement\Controllers;

use Illuminate\Routing\Controller;
use App\Features\VaccineManagement\Models\Vaccine;

class VaccineController extends Controller
{
    public function index()
    {
        return Vaccine::all();
    }
}
```

### Passo 4: Criar Service

```php
// app/Features/VaccineManagement/Services/VaccineService.php
namespace App\Features\VaccineManagement\Services;

use App\Features\VaccineManagement\Models\Vaccine;

class VaccineService
{
    public function getAllVaccines()
    {
        return Vaccine::all();
    }
}
```

### Passo 5: Registrar Rotas

Em `routes/api.php` ou `routes/web.php`:

```php
use App\Features\VaccineManagement\Controllers\VaccineController;

Route::apiResource('vaccines', VaccineController::class);
```

### Passo 6: Criar Migration

```bash
php artisan make:migration create_vaccines_table
```

Editar em `database/migrations/`:

```php
public function up()
{
    Schema::create('vaccines', function (Blueprint $table) {
        $table->id();
        $table->string('name');
        $table->text('description');
        $table->string('dosage');
        $table->timestamps();
    });
}
```

---

## Migrações e Factories

### Localização

- **Migrações globais:** `database/migrations/`
- **Factories globais:** `database/factories/`

### Naming Convention para Migrations

```
database/migrations/YYYY_MM_DD_HHMMSS_create_cattle_table.php
database/migrations/2025_12_06_120000_create_cattle_table.php
```

### Exemplo de Migration

```php
// database/migrations/2025_12_06_000000_create_cattle_table.php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('cattle', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('breed');
            $table->integer('age');
            $table->enum('status', ['healthy', 'ill', 'recovering', 'deceased']);
            $table->foreignId('farm_id')->constrained('farms');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cattle');
    }
};
```

### Exemplo de Factory

```php
// database/factories/CattleFactory.php
namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class CattleFactory extends Factory
{
    public function definition(): array
    {
        return [
            'name' => $this->faker->name(),
            'breed' => $this->faker->word(),
            'age' => $this->faker->numberBetween(1, 10),
            'status' => $this->faker->randomElement(['healthy', 'ill', 'recovering']),
        ];
    }
}
```

---

## Integração com Laravel Padrão

### Rotas

Mantenha rotas em `routes/api.php` ou `routes/web.php`:

```php
// routes/api.php
use App\Features\Cattle\Controllers\CattleController;
use App\Features\Farm\Controllers\FarmController;

Route::apiResource('cattle', CattleController::class);
Route::apiResource('farms', FarmController::class);
```

### Configuração

Configurações globais em `config/` continuam no mesmo lugar:

```php
// config/app.php
'providers' => [
    // ...
],
```

### Service Providers

Crie providers específicos para features se necessário:

```php
// app/Features/Cattle/Providers/CattleServiceProvider.php
namespace App\Features\Cattle\Providers;

use Illuminate\Support\ServiceProvider;

class CattleServiceProvider extends ServiceProvider
{
    public function register()
    {
        // Registrar bindings
    }

    public function boot()
    {
        // Boot services
    }
}
```

Registre em `config/app.php`:

```php
'providers' => [
    // ...
    App\Features\Cattle\Providers\CattleServiceProvider::class,
],
```

---

## Regras e Limites

### Máximo de Features Recomendado

- **1-5 features:** Estrutura ideal
- **6-15 features:** Escalável sem problemas
- **15+ features:** Considerar refatoração ou migrar para DDD

### Quando Refatorar

Se uma feature crescer além de 500 linhas de código total, considere dividir em subfeatures:

```
Features/Cattle/
├── Management/          # Gestão básica
│   ├── Models/
│   └── Controllers/
└── HealthMonitoring/    # Monitoramento de saúde
    ├── Models/
    └── Controllers/
```

### Quando Evoluir para DDD

Se o projeto atingir:
- 20+ features
- Regras de negócio muito complexas
- Contextos limitados bem definidos
- Múltiplos bancos de dados

Então migrate para Domain-Driven Design.

---

## Exemplos de Código

### Model em Feature

```php
// app/Features/Cattle/Models/Cattle.php
namespace App\Features\Cattle\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Cattle extends Model
{
    protected $fillable = ['name', 'breed', 'age', 'status', 'farm_id'];

    protected $casts = [
        'status' => CattleStatus::class,
    ];

    public function farm(): BelongsTo
    {
        return $this->belongsTo(Farm::class);
    }
}
```

### Service

```php
// app/Features/Cattle/Services/CattleService.php
namespace App\Features\Cattle\Services;

use App\Features\Cattle\Models\Cattle;
use App\Shared\DTOs\CattleDTO;

class CattleService
{
    public function createCattle(CattleDTO $dto): Cattle
    {
        return Cattle::create([
            'name' => $dto->name,
            'breed' => $dto->breed,
            'age' => $dto->age,
            'status' => $dto->status,
        ]);
    }

    public function getAllCattle()
    {
        return Cattle::all();
    }
}
```

### Repository

```php
// app/Features/Cattle/Repositories/CattleRepository.php
namespace App\Features\Cattle\Repositories;

use App\Features\Cattle\Models\Cattle;

class CattleRepository
{
    public function getHealthyCattle()
    {
        return Cattle::where('status', 'healthy')->get();
    }

    public function getCattleByFarm(int $farmId)
    {
        return Cattle::where('farm_id', $farmId)->get();
    }
}
```

### Request Validation

```php
// app/Features/Cattle/Requests/StoreCattleRequest.php
namespace App\Features\Cattle\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreCattleRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'breed' => 'required|string|max:255',
            'age' => 'required|integer|min:0',
            'status' => 'required|in:healthy,ill,recovering,deceased',
        ];
    }
}
```

### API Resource

```php
// app/Features/Cattle/Resources/CattleResource.php
namespace App\Features\Cattle\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class CattleResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'breed' => $this->breed,
            'age' => $this->age,
            'status' => $this->status,
            'farm' => $this->farm?->name,
            'created_at' => $this->created_at,
        ];
    }
}
```

---

## Best Practices

1. **Manter Features Independentes:** Evite dependências circulares entre features
2. **Usar Shared para Reutilização:** Código comum deve ir para Shared, não para Core
3. **Documentar Estrutura:** Quando criar nova feature complexa, document a em markdown
4. **Testes Próximos ao Código:** Coloque testes próximos à feature que testam
5. **Não Quebrar Laravel:** Mantenha convenções Laravel onde fizerem sentido
6. **Revisar Periodicamente:** Verifique se estrutura ainda faz sentido conforme app cresce

---

## Roadmap Futuro

- Quando atingir 15+ features bem definidas, considerar migração para DDD
- Possibilidade de evoluir features em microserviços separados
- Integração com API externa (WhatsApp, pg-vector)
- Implementação de Event Sourcing se comportamento fica muito complexo

---

**Versão:** 1.0
**Data:** Dezembro 2025
**Arquitetura:** Feature-Based
**Status:** Pronto para Produção
