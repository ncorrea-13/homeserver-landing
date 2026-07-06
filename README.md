# portfolio

Portfolio público de mi homeserver personal: quién soy, mi experiencia y mis proyectos.

Corre 24/7 detrás de Tailscale Funnel como única superficie de ese servidor expuesta directamente a internet; todo lo demás (Vaultwarden, Immich, Cockpit, etc.) queda en la tailnet privada. Este repo es solo la réplica del sitio, separada del repo completo del homeserver, que tiene la configuración de red y el resto de los servicios.

## Por qué estático

Sin backend, sin JS de terceros, sin formularios ni cookies: no hay lógica de servidor ni input de usuario, así que no hay superficie de inyección que auditar. Es la misma filosofía que aplico al resto de la infraestructura: Exponer lo mínimo posible.

## Contenido del sitio

- Presentación personal y stack técnico
- Experiencia, educación y CV descargable
- Proyectos personales y académicos, con filtro por tecnología
- Arquitectura del homeserver completa: diagrama, stack, decisiones y trade-offs

## Estructura

- `md/` ficheros fuentes en Markdown de cada página.
- `html/` el sitio generado, tal cual se sirve.
- `build.sh` convierte `md/` a `html/` vía pandoc + prettier.
- `service/` unit de systemd para publicar el uptime del servidor; se instala aparte, en el host real.

## Generar el sitio

```bash
./build.sh
```

Requiere `pandoc` y `npx` (para `prettier`) instalados.

## Repo relacionado

La configuración de Tailscale, los compose files y el resto de los servicios del homeserver viven en [github.com/ncorrea-13/homeserver](https://github.com/ncorrea-13/homeserver), bajo licencia MIT.
