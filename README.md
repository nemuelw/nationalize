# nationalize

Nim wrapper for the [Nationalize.io](https://nationalize.io) API

## Installation

```bash
nimble install nationalize
```

## Usage

### Import the package

```nim
import nationalize
```

### Initialize a client

```nim
let client = newNationalizeClient("OPTIONAL_API_KEY")
```

### Predict the nationality of a single name

```nim
let nationalityResult = client.predictNationality("Nemuel")
if isOk(nationalityResult):
  echo nationalityResult.value.country
else: echo nationalityResult.error
```

### Predict the nationalities of multiple names

```nim
let nationalitiesResult = client.predictNationalities(@["Nemuel", "Kira"])
if isOk(nationalitiesResult):
  for result in nationalitiesResult.value:
    echo result.country
else: echo nationalitiesResult.error
```

## Contributing

Contributions are welcome! Feel free to create an issue or open a pull request.

## License

This project is licensed under the terms of the [GNU GPL v3.0 License](https://www.gnu.org/licenses/gpl-3.0.html).
