export interface FilterValue {
  id: string
  slug: string
  name: string
  count?: number
}

export interface IFilter {
  id: string
  type: string
  name: string
  slug: string
  values: FilterValue[]
  // "id": "QXR0cmlidXRlOjcwOA==",
  // "name": "Destinat pentru",
  // "slug": "audio-adapter-destination",
  // "values": [
  //   {
  //     "id": "QXR0cmlidXRlVmFsdWU6MzM5MA==",
  //     "slug": "adaptare-semnal",
  //     "name": "Adaptare semnal"
  //   },
  //   {
  //     "id": "QXR0cmlidXRlVmFsdWU6MzM5MQ==",
  //     "slug": "semnal",
  //     "name": "Semnal"
  //   }
  // ]
}
