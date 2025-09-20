# Delphi Components Repository

Este repositorio contiene una colección de componentes esenciales para RAD Studio Delphi 12, organizados para una instalación rápida y eficiente en nuevos entornos de desarrollo.

## 📋 Componentes Incluidos

### 🔧 Gestión de Dependencias
- **Boss** - Gestor de dependencias para Delphi
- **Spring4D** - Framework de inyección de dependencias para Delphi

### 🌐 Componentes Web/REST
- **Horse** - Framework web minimalista para crear APIs REST
- **RESTRequest4Delphi** - Cliente REST avanzado para Delphi
- **Dataset-Serialize** - Serialización JSON para datasets
- **Dataset-Serialize-Adapter-RESTRequest4Delphi** - Adaptador para integrar serialización con REST

### 🔐 Seguridad
- **DCPcrypt2-2010** - Biblioteca de criptografía

### 🤖 Inteligencia Artificial
- **Delphi-AI-Developer** - Herramientas de IA para desarrollo

### 📊 Componentes UI/Data
- **DevExpress VCL 23.2.6 Full Source** - Suite completa de componentes UI
- **DevExpress VCL Demos** - Ejemplos y demostraciones
- **TMS VCL UI Pack Source 13.0.4.0** - Componentes UI adicionales
- **EMS Advanced Data Import 3.13** - Importación avanzada de datos
- **FastReport 2023-2 VCL Enterprise** - Generación de reportes

### 🛠️ Utilidades
- **DxAutoInstaller 2.3.7** - Instalador automático para DevExpress
- **UpdateBuilder** - Constructor de actualizaciones
- **NumWords** - Conversión de números a palabras

## 🚀 Instalación Rápida

### Prerrequisitos
- RAD Studio Delphi 12
- Git instalado
- Privilegios de administrador (para algunos componentes)

### Pasos de Instalación

1. **Clonar este repositorio:**
   ```bash
   git clone <URL_DEL_REPOSITORIO> C:\Tools-Projects\Delphi
   ```

2. **Configurar variables de entorno:**
   - Agregar `C:\Tools-Projects\Delphi` a tu PATH si es necesario
   - Configurar DELPHI_PATH apuntando a tu instalación de RAD Studio

3. **Instalar componentes en orden recomendado:**

   **Paso 1: Gestión de dependencias**
   ```bash
   # Instalar Boss primero
   cd boss
   # Seguir instrucciones específicas del componente
   ```

   **Paso 2: Frameworks base**
   ```bash
   # Spring4D
   cd Spring4D
   # Compilar e instalar
   ```

   **Paso 3: Componentes comerciales**
   - DevExpress VCL (usar DxAutoInstaller)
   - TMS VCL UI Pack
   - FastReport Enterprise

   **Paso 4: Frameworks web**
   - Horse
   - RESTRequest4Delphi
   - Dataset-Serialize

## 📁 Estructura del Repositorio

```
├── boss/                          # Gestor de dependencias
├── dataset-serialize-master/      # Serialización JSON
├── dataset-serialize-adapter-restrequest4delphi/ # Adaptador REST
├── dcpcrypt2-2010/               # Criptografía
├── Delphi-AI-Developer-master/   # Herramientas IA
├── DevExpress VCL 23.2.6 Full Source/ # DevExpress completo
├── DevExpress VCL Demos/         # Demos DevExpress
├── DxAutoInstaller 2.3.7/        # Auto-instalador DevExpress
├── EMS Advanced Data Import 3.13/ # Importación datos
├── FastReport 2023-2 VCL Enterprise/ # Reportes
├── horse/                        # Framework web
├── NumWords/                     # Utilidad números
├── RESTRequest4Delphi-master/    # Cliente REST
├── Spring4D/                     # Framework DI
├── TMS VCL UI Pack Source 13.0.4.0/ # Componentes TMS
├── UpdateBuilder/                # Constructor actualizaciones
├── .gitignore                    # Archivos excluidos
└── README.md                     # Este archivo
```

## 🔧 Configuración Post-Instalación

### Variables de Sistema Recomendadas
- `BDS`: Ruta a RAD Studio
- `BDSLIB`: Ruta a librerías
- `DELPHI_ROOT`: Directorio raíz de Delphi
- `COMPONENTS_PATH`: Ruta a este repositorio

### Library Path
Agregar a Tools > Options > Language > Delphi > Library:
- `C:\Tools-Projects\Delphi\horse\src`
- `C:\Tools-Projects\Delphi\RESTRequest4Delphi-master\src`
- `C:\Tools-Projects\Delphi\dataset-serialize-master\src`
- `C:\Tools-Projects\Delphi\Spring4D\Source`

## 📝 Notas Importantes

⚠️ **Orden de instalación:** Algunos componentes dependen de otros. Seguir el orden recomendado.

⚠️ **Licencias:** Verificar las licencias de los componentes comerciales antes de usar en producción.

⚠️ **Compatibilidad:** Todos los componentes están probados con RAD Studio Delphi 12.

## 🤝 Contribución

Este es un repositorio personal para backup y sincronización rápida de componentes. 

## 📄 Licencia

Los componentes incluidos mantienen sus licencias originales. Este repositorio es solo para organización y backup personal.

---

**Última actualización:** $(date)  
**RAD Studio Version:** 12  
**Plataformas soportadas:** Windows, macOS, Linux (según componente)