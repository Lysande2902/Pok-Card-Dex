# PokéCard Dex - Lista Infinita con Flutter

Este proyecto es una aplicación móvil desarrollada en Flutter que muestra una lista infinita de cartas de Pokémon TCG. La aplicación está construida siguiendo prácticas de ingeniería de software de nivel profesional, enfocándose en una arquitectura limpia, escalable y mantenible.

El objetivo principal de este proyecto no es solo mostrar una lista, sino demostrar cómo construir una funcionalidad compleja utilizando herramientas y patrones de diseño modernos como lo haría un desarrollador senior.

## ¿Qué debe mostrar la aplicación?

La aplicación "PokéCard Dex" debe presentar al usuario una lista vertical de cartas de Pokémon. Al iniciar, cargará el primer lote de cartas desde la API de Pokémon TCG. A medida que el usuario se desplace hacia el final de la lista, la aplicación solicitará y añadirá automáticamente más cartas, creando una experiencia de "scroll infinito".

La interfaz debe manejar e indicar visualmente los siguientes estados:
- **Estado de Carga Inicial:** Un indicador de progreso mientras se obtiene el primer conjunto de cartas.
- **Estado de Éxito:** La lista de cartas de Pokémon, mostrando la imagen y el nombre de cada una.
- **Carga Adicional:** Un indicador de carga en la parte inferior de la lista cuando se están obteniendo más cartas.
- **Fin de la Lista:** La lista dejará de mostrar el indicador de carga inferior una vez que se hayan obtenido todas las cartas disponibles.
- **Estado de Error:** Un mensaje que informe al usuario si ocurrió un problema al obtener los datos.

## Arquitectura y Tecnologías

Este proyecto se adhiere a los principios de la **Arquitectura Limpia** para garantizar una clara separación de responsabilidades, lo que resulta en un código modular, comprobable y fácil de mantener. La arquitectura se divide en tres capas principales:

1.  **Capa de Presentación:** Responsable de la interfaz de usuario. Utiliza el patrón **BLoC (Business Logic Component)** para gestionar el estado de la aplicación de una manera predecible y eficiente, separando la lógica de la interfaz de usuario.
2.  **Capa de Dominio:** El núcleo de la aplicación. Contiene la lógica de negocio y las reglas esenciales (Entidades y Repositorios abstractos) escritas en Dart puro, sin depender de ningún framework o fuente de datos externa.
3.  **Capa de Datos:** Implementa la lógica para obtener los datos de fuentes externas. Se comunica con la API de Pokémon TCG utilizando el paquete `dio` para realizar solicitudes de red robustas y manejar los errores.

El proyecto fue inicializado con `very_good_cli`, que proporciona una base sólida y opinada con soporte para sabores (development, staging, production), internacionalización y un estricto conjunto de reglas de análisis estático (`very_good_analysis`) para asegurar la alta calidad del código.

## Próximos Pasos y Funcionalidades Futuras

El proyecto está diseñado para ser expandido. Algunas de las funcionalidades que se pueden implementar a continuación son:

-   **Vista de Detalle:** Navegar a una nueva pantalla al tocar una carta para mostrar más información sobre ella.
-   **Pull-to-Refresh:** Implementar la funcionalidad de "tirar para refrescar" para volver a cargar la lista desde el principio.
-   **Búsqueda por Nombre:** Añadir una barra de búsqueda para encontrar cartas por su nombre.
-   **Filtros Avanzados:** Permitir a los usuarios filtrar las cartas por tipo (ej. "Fuego", "Agua") a través de un menú lateral (Drawer).
-   **Pruebas Unitarias:** Escribir pruebas para el `PokemonCardBloc` para garantizar que la lógica de negocio funcione como se espera en todos los escenarios (éxito, error, etc.).