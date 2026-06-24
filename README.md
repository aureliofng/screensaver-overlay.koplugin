# ScreensaverOverlay - Plugin para KOReader

Superpone una imagen PNG con transparencia sobre la página que estás leyendo al suspender el dispositivo.

<!-- SCREENSHOT PRINCIPAL -->
<!-- Agrega aquí una foto del efecto en tu Kobo -->
<!-- ![Demo](images/demo.jpg) -->

---

## ¿Cómo funciona?

Al cerrar la tapa o suspender el dispositivo, el plugin toma una imagen aleatoria de tu carpeta y la muestra encima de la página actual. Donde la imagen es transparente, se ve el texto del libro debajo.

La imagen **solo cambia** si leíste desde el último bloqueo. Si abres y cierras sin leer, mantiene la misma imagen.

<!-- DIAGRAMA O GIF OPCIONAL -->
<!-- ![Funcionamiento](images/how-it-works.gif) -->

---

## Requisitos

- KOReader v2024 o superior
- Kobo con KOReader instalado (probado en **Kobo Clara HD**)
- Imágenes PNG con canal alpha (transparencia)

---

## Instalación

### 1. Descarga el plugin

Ve a [Releases](../../releases) y descarga el archivo `.zip` más reciente.

### 2. Copia la carpeta al Kobo

Conecta el Kobo al PC y copia la carpeta `screensaver_overlay.koplugin` a:

```
KOBOeReader\.adds\koreader\plugins\
```

La estructura debe quedar así:

```
KOBOeReader\
  .adds\
    koreader\
      plugins\
        screensaver_overlay.koplugin\
          main.lua
          _meta.lua
```

### 3. Crea la carpeta de imágenes

Crea esta carpeta en tu Kobo:

```
KOBOeReader\.adds\screensaver_overlay\
```

Y pon dentro tus imágenes PNG con transparencia.

### 4. Reinicia KOReader

El plugin aparecerá en **Herramientas → Screensaver Overlay**.

---

## Imágenes recomendadas

- Formato: **PNG con canal alpha** (transparencia)
- Tamaño recomendado: **1072 × 1448 px** (Kobo Clara HD)
- El plugin escala automáticamente, pero imágenes al tamaño exacto se ven mejor

Puedes encontrar imágenes con transparencia para e-readers en:
- [readerbackdrop.com](https://www.readerbackdrop.com) — busca el filtro `transparent`

<!-- EJEMPLOS DE IMÁGENES -->
<!-- Agrega aquí fotos de diferentes overlays que hayas probado -->
<!--
| Imagen 1 | Imagen 2 |
|----------|----------|
| ![](images/example1.jpg) | ![](images/example2.jpg) |
-->

---

## Uso

Una vez instalado, en KOReader ve a:

**Menú → Herramientas → Screensaver Overlay**

| Opción | Descripción |
|--------|-------------|
| Carpeta | Muestra y permite cambiar la ruta de las imágenes |
| Probar overlay ahora | Muestra el overlay sin necesidad de suspender |
| Cerrar overlay | Cierra el overlay manualmente |

---

## Dispositivos probados

| Dispositivo | Firmware | Estado |
|-------------|----------|--------|
| Kobo Clara HD | 4.38.23697 | ✅ Funciona |
| | | |
| | | |

<!-- Agrega tu dispositivo si lo pruebas -->

---

## Versiones

| Versión | Cambios |
|---------|---------|
| 1.8 | Versión estable. RenderImage para manejo de memoria, imagen cambia solo con actividad |
| 1.7 | Limpieza de código |
| 1.6 | RenderImage para escalar al cargar |
| 1.5 | Fix de memoria |
| 1.4 | Fix de menú, is_doc_only |
| 1.3 | Intento de cubrir barra de estado |
| 1.2 | modal=true para quedar encima de barras |
| 1.1 | Ruta corregida a .adds/screensaver_overlay |
| 1.0 | Primera versión funcional |

---

## Problemas conocidos

- La barra de estado de KOReader sigue visible sobre el overlay (limitación del sistema)
- Imágenes muy grandes pueden causar error de memoria en dispositivos antiguos

---

## Contribuir

<!-- Agrega aquí cómo quieres que la gente contribuya -->

Si encuentras un bug o tienes una sugerencia, abre un [Issue](../../issues).

---

## Licencia

<!-- Agrega la licencia que prefieras -->
<!-- MIT, GPL, etc. -->

---

*Desarrollado y probado en Urabá, Colombia 🇨🇴*
