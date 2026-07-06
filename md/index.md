---
pagetitle: Nicolás Correa
lang: es
---

<nav class="site-nav">
  <a href="index.html">Inicio</a>
  <a href="sobre-mi.html">Sobre mí</a>
  <a href="proyectos.html">Proyectos</a>
  <a href="sobre-el-proyecto.html">Arquitectura del homeserver</a>
  <button class="theme-toggle" id="theme-toggle" aria-label="Cambiar tema" onclick="toggleTheme()">◐</button>
</nav>

<div class="hero">
<img class="hero-photo" src="foto.jpg" alt="Nicolás Correa" />
<div>
<h1 class="hero-name">Nicolás Correa</h1>
<p class="hero-tagline">Developer full-stack · Sysadmin & homelab · Red Team Trainee</p>
</div>
</div>

Estudiante avanzado de Ingeniería en Sistemas de Información y desarrollador full-stack en AYSAM. Me interesa tanto construir sistemas como entender cómo se rompen. Combino desarrollo de software con formación en ciberseguridad ofensiva.

<div class="tag-group">
  <p class="tag-group-label">Backend</p>
  <div class="tag-row">
    <span class="tag">Java · Spring Boot</span>
    <span class="tag">GraphQL · RabbitMQ</span>
    <span class="tag">Node.js · Express.js</span>
    <span class="tag">PL/SQL</span>
    <span class="tag">PostgreSQL</span>
  </div>
</div>
<div class="tag-group">
  <p class="tag-group-label">Frontend</p>
  <div class="tag-row">
    <span class="tag">JavaScript · TypeScript</span>
    <span class="tag">Node.js · React · Next.js</span>
    <span class="tag">Oracle APEX</span>
  </div>
</div>

<div class="tag-group">
  <p class="tag-group-label">Seguridad ofensiva</p>
  <div class="tag-row">
    <span class="tag">Nmap</span>
    <span class="tag">Burp Suite</span>
    <span class="tag">OSINT</span>
    <span class="tag">Python</span>
  </div>
</div>
<div class="tag-group">
  <p class="tag-group-label">Infraestructura</p>
  <div class="tag-row">
    <span class="tag">Bash</span>
    <span class="tag">Docker</span>
    <span class="tag">Linux avanzado</span>
    <span class="tag">Microservicios</span>
    <span class="tag">Podman</span>
    <span class="tag">Redes</span>
    <span class="tag">Wireguard</span>
  </div>
</div>

<div align="center">
  <a href="cv.pdf" class="btn" target="_blank" rel="noopener">Descargar CV</a>
  <a href="proyectos.html" class="btn">Ver proyectos</a>
  <a href="sobre-mi.html" class="btn">Sobre mí</a>
</div>

## Destacado

Este mismo sitio se está hosteando 100% en mi **homeserver personal**. Actualmente me encuentro trabajando con infraestructura self-hosted, contenedores y privacidad aplicada a un uso diario real, corriendo 24/7 detrás de [Tailscale](https://tailscale.com).

<div class="uptime-box compact">
  <p class="uptime-label" id="uptime-label">El último reinicio fue el …</p>
  <p class="uptime-value" id="uptime-counter">calculando…</p>
</div>
<script>
(function() {
  var counterEl = document.getElementById('uptime-counter');
  var labelEl = document.getElementById('uptime-label');
  var bootEpoch = null;

function formatFecha(d) {
return d.toLocaleDateString('es-AR', { day: 'numeric', month: 'long', year: 'numeric' });
}

function update() {
if (bootEpoch === null) return;
var diff = Date.now() - bootEpoch * 1000;
var days = Math.floor(diff / 86400000);
var hours = Math.floor((diff % 86400000) / 3600000);
var mins = Math.floor((diff % 3600000) / 60000);
var secs = Math.floor((diff % 60000) / 1000);
counterEl.textContent = days + 'd ' + hours + 'h ' + mins + 'm ' + secs + 's';
}

fetch('boot.json', { cache: 'no-store' })
.then(function(r) { return r.json(); })
.then(function(data) {
bootEpoch = data.boot_epoch;
labelEl.textContent = 'El último reinicio fue el ' + formatFecha(new Date(bootEpoch * 1000));
update();
setInterval(update, 1000);
})
.catch(function() {
labelEl.textContent = 'Activo desde';
counterEl.textContent = 'uptime no disponible';
});
})();
</script>

El detalle técnico completo se puede encontrar en la sección de [arquitectura del homeserver](sobre-el-proyecto.html). Su configuración se puede encontrar [en github](https://github.com/ncorrea-13/homeserver).

## Contacto

<div align="center">
  <a href="mailto:ncorrea13@proton.me">
    <img src="https://img.shields.io/static/v1?message=Mail&logo=protonmail&label=&color=6D4AFF&logoColor=white&style=for-the-badge" height="25" alt="protonmail" />
  </a>
  <a href="https://www.linkedin.com/in/nicolas-correa-serrat/">
    <img src="https://img.shields.io/badge/LinkedIn-%230077B5.svg?label=&color=0077B5&logoColor=white&style=for-the-badge&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0id2hpdGUiPjxwYXRoIGQ9Ik0yMC40NDcgMjAuNDUyaC0zLjU1NHYtNS41NjljMC0xLjMyOC0uMDI3LTMuMDM3LTEuODUyLTMuMDM3LTEuODUzIDAtMi4xMzYgMS40NDUtMi4xMzYgMi45Mzl2NS42NjdIOS4zNTFWOWgzLjQxNHYxLjU2MWguMDQ2Yy40NzctLjkgMS42MzctMS44NSAzLjM3LTEuODUgMy42MDEgMCA0LjI2NyAyLjM3IDQuMjY3IDUuNDU1djYuMjg2ek01LjMzNyA3LjQzM2MtMS4xNDQgMC0yLjA2My0uOTI2LTIuMDYzLTIuMDY1IDAtMS4xMzguOTItMi4wNjMgMi4wNjMtMi4wNjMgMS4xNCAwIDIuMDY0LjkyNSAyLjA2NCAyLjA2MyAwIDEuMTM5LS45MjUgMi4wNjUtMi4wNjQgMi4wNjV6bTEuNzgyIDEzLjAxOUgzLjU1NVY5aDMuNTY0djExLjQ1MnpNMjIuMjI1IDBIMS43NzFDLjc5MiAwIDAgLjc3NCAwIDEuNzI5djIwLjU0MkMwIDIzLjIyNy43OTIgMjQgMS43NzEgMjRoMjAuNDUxQzIzLjIgMjQgMjQgMjMuMjI3IDI0IDIyLjI3MVYxLjcyOUMyNCAuNzc0IDIzLjIgMCAyMi4yMjUgMHoiLz48L3N2Zz4=" height="25" alt="linkedin" />
  </a>
  <a href="https://wa.me/5492612582481">
    <img src="https://img.shields.io/static/v1?message=WhatsApp&logo=whatsapp&label=&color=25D366&logoColor=white&style=for-the-badge" height="25" alt="whatsapp" />
  </a>
</div>

Este sitio es solo informativo — no hay recolección de datos.

---

_Última actualización: julio 2026 · [MIT License](https://github.com/ncorrea-13/homeserver-landing/blob/main/LICENSE)_
