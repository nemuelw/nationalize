import httpclient, jsony, results, sequtils, strformat, strutils

const BaseUrl = "https://api.nationalize.io/?"

type
  NationalizeClient* = object
    apiKey*: string
    client*: HttpClient

  Country* = object
    country_id*: string
    probability*: float

  Nationality* = object
    name*: string
    count*: int
    country*: seq[Country]

  Error* = object
    error*: string

proc makeRequest[T](self: NationalizeClient, url: string): Result[T, string] =
  var url = url
  if self.apiKey.len > 0:
    url = fmt"{url}&apikey={self.apiKey}"

  let response = self.client.request(url)
  let body = response.body
  if response.status != "200 OK":
    let error = body.fromJson(Error)
    return err(error.error)

  return ok(body.fromJson(T))

proc newNationalizeClient*(apiKey = ""): NationalizeClient =
  ## initialize a new client for interacting with the API
  ##
  ## params:
  ##  `apiKey`: optional API key
  ##
  ## returns:
  ##  `NationalizeClient`

  result.apiKey = apiKey
  result.client = newHttpClient()
  result.client.headers = newHttpHeaders({"User-Agent": "nationalize/0.1.0 (Nim)"})

proc predictNationality*(self: NationalizeClient, name: string): Result[Nationality, string] =
  ## predict the nationality of a single name
  ##
  ## params:
  ##  `name`: name whose nationality is to be predicted
  ##
  ## returns:
  ##  `Result[Nationality, string]`

  var url = fmt"{BaseUrl}name={name}"
  return makeRequest[Nationality](self, url)

proc predictNationalities*(self: NationalizeClient, names: seq[string]): Result[seq[Nationality], string] =
  ## predict the nationalities of a list of names
  ##
  ## params:
  ##  `names`: list of names whose nationalities are to be predicted
  ##
  ## returns:
  ##  `Result[seq[Nationality], string]`

  let namesParam = names.mapIt(fmt"name[]={it}").join("&")
  var url = fmt"{BaseUrl}{namesParam}"

  return makeRequest[seq[Nationality]](self, url)
