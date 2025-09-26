# COMP3900 2025 - Toastie base project

Provided:
- Figma mock up for the new feature: [link](https://www.figma.com/design/cm9rVMjnhAeC1vJBDVIaIl/COMP3900?node-id=0-1&p=f&t=nKKKh9yVrrAbSOBo-0)
- Starter code
- Custom component library

# Figma mock up notes

# Start code notes
- We provide one example of the service, repository, client & use of injection
- Use the given entity structure for your database tables. You shouldn't need to modify these but you can if needed, just make a note of any changes you make

📂 Project Structure Overview

Core Layer (lib/core/): Contains shared, reusable building blocks used across multiple features.
📂 core/
constants/ – app-wide constants (colors, spacing, etc.).
utils/ – helper functions, formatters, validators, etc.
theme/ – global styles, typography, and theme definitions.

Features Layer (lib/features/): Each feature is self-contained with its own domain logic, UI, and state management.
📂 feature_name/
- data/ – data sources, repositories, API calls, database queries.
- models/ – entities/data classes specific to this feature.
- providers/ – state management 
- view/ – screens, widgets, and UI specific to this feature.
- widgets/ – feature-specific reusable components
- feature_name.dart file, which will have all exports in this directory. Only add exports if they need to be shared across multiple feature directories

Each feature should be independently testable and not tightly coupled to other features.

# Custom component library notes
- Re-use custom component where possible. Ok to refactor. Can make new components
- Use provided colors only with the exception of Colors.white 
- Use provided font styling only. Choose the one closest to the Figma mocks if the exact size is missing.
- Any padding or border radius is usually already defined. Make sure everything is in multiples of gridbaseline 
