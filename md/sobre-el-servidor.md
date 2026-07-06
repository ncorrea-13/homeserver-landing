---
pagetitle: Arquitectura del homeserver
lang: es
---

<nav class="site-nav">
  <a href="index.html">Inicio</a>
  <a href="sobre-mi.html">Sobre mí</a>
  <a href="proyectos.html">Proyectos</a>
  <a href="sobre-el-proyecto.html">Arquitectura del homeserver</a>
  <button class="theme-toggle" id="theme-toggle" aria-label="Cambiar tema" onclick="toggleTheme()">◐</button>
</nav>

# Arquitectura del homeserver

## Filosofía

Infraestructura privada, modular y de bajo mantenimiento. Sin telemetría, sin dependencia de servicios cloud comerciales, con cero puertos expuestos al público salvo esta misma web. Actualmente de forma dinámica administro la apertura al público por tailscale funnel a medida de mis necesitades.

Cada stack corre como un pod de Podman independiente, gestionado como servicio de `systemd` a nivel usuario. Esto mantiene las responsabilidades aisladas: reiniciar o actualizar un pod no afecta a los demás.

## Arquitectura

<img src="diagrama-arquitectura.svg" alt="Diagrama de las dos rutas de entrada al homeserver: Tailscale Funnel hacia la landing pública, y Tailscale WireGuard hacia el resto del homeserver y sus pods" style="width:100%;height:auto;" />

<pre class="mermaid">
graph TD

    subgraph Internet_Publico ["Internet Público"]
        Visitor["Visitante / Reclutador"]
    end

    subgraph Tailnet_Privada ["Tailnet Privada - Tailscale"]
        Owner["Dispositivos Autenticados<br/>(Único acceso a todo lo demás)"]
    end

    subgraph Host_Server ["Host: Debian 13 Trixie<br/>(único puerto abierto en LAN: 22/SSH)"]

        TSFunnel["Tailscale Funnel<br/>(expone SOLO la landing a Internet)"]
        TSServe["Tailscale + MagicDNS<br/>Proxy HTTPS único<br/>(misma URL, cambia puertos internamente<br/>hacia cada servicio)"]

        Landing["Landing Page Portfolio<br/>HTML / CSS / JS estático<br/>servido directo por Tailscale Serve<br/>(sin servidor web propio)"]

        Cockpit["Cockpit<br/>Corre en el Host, fuera de Podman<br/>Solo accesible vía Tailnet HTTPS"]

        Cron["Cron Jobs<br/>Backups programados"]

        subgraph Podman_Engine ["Podman (rootless) - Pods"]

            PodmanRoot["Motor Podman"]

            subgraph Pod_Core ["Pod: Core"]
                Vaultwarden["Vaultwarden"]
                Radicale["Radicale"]
            end

            subgraph Pod_Network ["Pod: Network"]
                Pihole["Pi-hole<br/>(filtrado DNS)"]
                Unbound["Unbound<br/>DoT → Mullvad"]
            end

            subgraph Pod_Storage ["Pod: Storage"]
                Syncthing["Syncthing"]
                Filebrowser["Filebrowser"]
            end

            subgraph Pod_Utils ["Pod: Utils"]
                Homepage["Homepage"]
                Ntfy["Ntfy"]
                Kuma["Uptime Kuma"]
            end

            subgraph Pod_Immich ["Pod: Immich"]
                ImmichSrv["Immich Server"]
                ImmichML["Immich Machine Learning"]
            end

            subgraph Pod_Entertainment ["Pod: Entertainment"]
                Miniflux["Miniflux"]
                Suwayomi["Suwayomi"]
                Kavita["Kavita"]
                Flaresolverr["Flaresolverr"]
            end

        end
    end

    subgraph Almacenamiento ["Hardware: Almacenamiento"]
        SSD_OS[("SSD 120GB<br/>Sistema Operativo")]
        SSD_Data[("SSD 480GB<br/>Datos: volúmenes Podman<br/>(todos los contenedores)")]
        HDD_Daily[("HDD 2.5 pulg 480GB<br/>Backup Diario")]
        HDD_Weekly[("HDD 2.5 pulg 480GB<br/>Backup Semanal")]
    end

    subgraph Salida_DNS ["Salida DNS Externa"]
        Mullvad[("Mullvad DNS<br/>vía DoT")]
    end

    %% Conexiones de acceso
    Visitor --> TSFunnel
    TSFunnel --> Landing

    Owner --> TSServe
    TSServe --> Cockpit
    TSServe --> PodmanRoot
    PodmanRoot --> Pod_Core
    PodmanRoot --> Pod_Network
    PodmanRoot --> Pod_Storage
    PodmanRoot --> Pod_Utils
    PodmanRoot --> Pod_Immich
    PodmanRoot --> Pod_Entertainment

    %% DNS
    Pihole --> Unbound
    Unbound -.->|DoT| Mullvad

    %% Notificaciones
    Kuma -.->|notifica| Ntfy

    %% Storage
    Landing -.-> SSD_OS
    Cockpit -.-> SSD_OS
    PodmanRoot ==> SSD_Data
    Cron --> HDD_Daily
    Cron --> HDD_Weekly
    SSD_Data -.->|backup| HDD_Daily
    SSD_Data -.->|backup| HDD_Weekly

    classDef public fill:#f9d5e5,stroke:#333,stroke-width:2px;
    classDef private fill:#d5e8d4,stroke:#333,stroke-width:2px;
    classDef host fill:#fff2cc,stroke:#333,stroke-width:2px;
    classDef storage fill:#e1d5e7,stroke:#333,stroke-width:2px;
    classDef dns fill:#cfe2f3,stroke:#333,stroke-width:2px;
    classDef standalone fill:#ffe6cc,stroke:#333,stroke-width:2px;

    class Visitor public;
    class Owner private;
    class Host_Server host;
    class Podman_Engine host;
    class Landing,Cockpit,TSFunnel,TSServe standalone;
    class PodmanRoot host;
    class SSD_OS,SSD_Data,HDD_Daily,HDD_Weekly storage;
    class Mullvad dns;
</pre>

### Notas de arquitectura

- **Acceso único:** el servidor no es accesible por red local. Todo el tráfico pasa exclusivamente por Tailscale; el único puerto permitido de entrada es 22/SSH por red LAN. Los puertos de cada servicio se redirigen internamente para el proxy de Tailscale.
- **Tailscale:** además de dar acceso privado, actúa como proxy único hacia todos los servicios (misma URL vía MagicDNS, cambiando de puerto según el servicio) y provee SSL en todos los casos.
- **Portfolio:** es la única excepción siempre disponible y expuesta a internet, mediante Tailscale Funnel sobre una ruta específica. Es HTML/CSS/JS estático, sin backend ni contenedor propio.
- **Cockpit:** corre directamente en el host (no en Podman), accesible únicamente vía Tailscale.
- **Webhook:** API instanciada para la habilitación dinámica de Tailscale Funnel. Permite instanciar en Homepage botones con scripts en bash para habilitar la salida externa de diversos servicios de forma dinámica.
- **Podman:** motor rootless que orquesta todos los pods de servicios. No incluye la landing ni Cockpit.
- **Bases de datos:** Redis y Postgres (Immich) y la base de Miniflux se omiten intencionalmente del diagrama por prolijidad.
- **Discos:** el SSD de 120GB es exclusivo del sistema operativo. El SSD de 480GB concentra todos los volúmenes de los contenedores. Los dos HDD de 2.5" (480GB cada uno) son destino de backups diario y semanal respectivamente.
- **DNS:** Pi-hole filtra consultas y las reenvía a Unbound, que sale a los servidores de Mullvad exclusivamente vía DoT.
- **Uso real:** Radicale guarda calendarios y contactos. Syncthing sincroniza notas de Obsidian, respaldo de WhatsApp, códigos 2FA encriptados y biblioteca de Calibre. Homepage se usa solo como launcher de apps (sin integración de API keys con Podman). Miniflux centraliza RSS de mis intereses personales.

## Stack técnico

- **Hardware:** Lenovo ThinkCentre M700 (i3-6100T, 8GB RAM)
- **Sistema operativo:** Debian Trixie (amd64)
- **Contenedores:** Podman rootless con `podman-compose`, orquestado vía `systemd` a nivel usuario
- **Red:** Tailscale (WireGuard) exclusivo de acceso remoto, sin puertos forwardeados en el router
- **Administración:** Cockpit para monitoreo de sistema y contenedores

## Servicios

**Core** — Vaultwarden (contraseñas), Radicale (calendarios y contactos)

**Gateway** — Pi-hole (bloqueo de publicidad), Unbound (DNS recursivo con DoT)

**Immich** — Backup y galería de fotos y videos con búsqueda por ML

**Entertainment** — Miniflux (RSS), Suwayomi (lector de comics), Kavita (biblioteca digital)

**Storage** — Syncthing (sincronización), Filebrowser (gestión de archivos)

**Utils** — Homepage (dashboard), Uptime Kuma (monitoreo), Ntfy (notificaciones push)

## Decisiones técnicas

- **Debian Trixie sobre alternativas**: Prioricé estabilidad y soporte de paquetes para un servidor que se va a encontrar siempre disponible y no debe recibir actualizaciones ni reinicios de forma inesperada.
- **Podman rootless en vez de Docker**: Menor superficie de ataque al no depender de un daemon corriendo como root.
- **Tailscale como único punto de acceso remoto** Cero puertos forwardeados en el router; toda conexión pasa por WireGuard autenticado.
- **Exposición pública mínima y temporal**: Solo esta página queda fija en Funnel; el resto de los servicios se exponen puntualmente y se apagan al terminar de usarlos.

## Trade-offs de arquitectura

**Origenes del proyecto**

Mi servidor personal inició por medio de una instancia de una Raspberry Pi 4b. Ahí comenzó este proyecto y con el cual he ido aprendiendo en mi día a día. Actualmente esa Raspberry Pi se encuentra vinculada al nodo principal permitiendo redundancia para los servicios primordiales como Vaultwarden, Pihole o Unbound. Así mantengo una alta disponibilidad ante cualquier inconveniente que pueda llegar a ocurrir

**Vaultwarden e Immich. Self-hosted vs. cloud (Bitwarden, Google Photos)**

En ambos casos el criterio fue el mismo: privacidad y control sobre datos sensibles (contraseñas y fotos personales). El costo es mantenimiento propio, backups, actualizaciones y disponibilidad que en un servicio cloud vendría resuelto de fábrica. Para este tipo de datos, priorizo ese control incluso a costa del trabajo extra. Este fue el principio para la construcción de este homeserver.

**Cockpit detrás de Tailscale Serve: doble TLS y CSRF**

Cockpit ya sirve su propia interfaz por HTTPS con certificado autofirmado. Al exponerlo detrás de `tailscale serve`, que también termina TLS, el resultado era una segunda capa de cifrado envolviendo a la primera — el navegador recibía una respuesta cifrada dos veces y fallaba al renderizar la interfaz.

Sumado a eso, Cockpit valida el header `Origin` de cada request como protección CSRF. Al llegar las requests desde el dominio de Tailscale (`*.ts.net`) en vez del hostname local que Cockpit esperaba, las rechazaba silenciosamente.

La solución fue configurar Cockpit para escuchar en HTTP plano localmente (dejando que Tailscale sea la única capa de TLS real) y agregar el dominio de Tailscale a los orígenes permitidos en la configuración de Cockpit, para que dejara de tratar esas requests como intentos de CSRF.

## Referencias

Documentación y fuentes técnicas usadas para diseñar esta infraestructura:

- [Tailscale Funnel](https://tailscale.com/kb/1223/funnel) y [Tailscale Serve](https://tailscale.com/kb/1242/tailscale-serve): exposición pública controlada sobre WireGuard.
- [Podman rootless](https://docs.podman.io/en/latest/markdown/podman.1.html#rootless-containers): contenedores sin daemon root, base de la superficie de ataque reducida.
- [systemd Rootless containers with Podman](https://docs.podman.io/en/latest/markdown/podman-generate-systemd.1.html): unidades de usuario para cada pod.
- [Cockpit Project](https://cockpit-project.org/): administración web del sistema y contenedores.
- [Pandoc](https://pandoc.org/): generador de esta misma landing a partir de Markdown.

## Código abierto

La configuración completa (compose files, scripts de deploy) está disponible en el repositorio:

[github.com/ncorrea-13/homeserver](https://github.com/ncorrea-13/homeserver)

---

_Última actualización: julio 2026 · [MIT License](https://github.com/ncorrea-13/homeserver-landing/blob/main/LICENSE)_
