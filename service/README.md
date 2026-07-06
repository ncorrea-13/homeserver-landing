# write-boot-time

Publica el uptime real del host (`uptime -s`) como un archivo estático
`boot.json` dentro del doc root, para que el contador de `index.html`
(`fetch('boot.json')`) lo lea. Corre **una sola vez al boot**, vía systemd
oneshot — no queda ningún proceso corriendo ni ningún endpoint respondiendo
a requests públicos.

Este directorio no se sirve públicamente ni se ejecuta desde este repo
(`landing` es solo la réplica local del sitio). Es para copiar al servidor
real y instalarlo ahí.

## Contenido

- `write-boot-time.sh` — lee `uptime -s`, escribe `boot.json` en `$DOC_ROOT`.
- `write-boot-time.service` — unit de systemd (oneshot, dispara al boot).
- `.env.example` — plantilla del env file con `DOC_ROOT`.

## Instalación en servidor productivo

```bash
# 1. Copiar el script
sudo cp write-boot-time.sh /usr/local/bin/write-boot-time.sh
sudo chmod +x /usr/local/bin/write-boot-time.sh

# 2. Crear el .env
sudo cp .env.example /etc/write-boot-time.env
sudo chmod 600 /etc/write-boot-time.env
sudoedit /etc/write-boot-time.env

# 3. Instalar el unit de systemd
sudo cp write-boot-time.service /etc/systemd/system/write-boot-time.service
sudo systemctl daemon-reload
sudo systemctl enable --now write-boot-time.service
```

## Verificar

```sh
systemctl status write-boot-time.service
cat "$DOC_ROOT/boot.json"
```

Si `DOC_ROOT` no está definido (falta el `.env` o el `EnvironmentFile` no
resuelve), el script falla explícitamente en vez de escribir en un lugar
equivocado.

## Por qué oneshot-al-boot y no un endpoint dinámico

El navegador no puede leer `/proc/uptime` del servidor directamente (JS de
browser no tiene acceso al filesystem del host remoto). La alternativa
"correcta" sería un endpoint que responda en cada request, pero eso agrega
un proceso vivo expuesto por Funnel. Un archivo estático regenerado una vez
por boot da el mismo dato con cero superficie nueva — mismo riesgo que
servir cualquier otro archivo estático del sitio.
