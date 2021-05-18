import { useEffect, useState } from 'react'
import { CategoryWithDepth, ICategory } from '../types'

export function useCategories() {
  const [categories, setCategories] = useState<CategoryWithDepth[]>([])

  useEffect(() => {

    const treeToList = (categories: ICategory[], depth = 0): CategoryWithDepth[] =>
      categories.reduce(
        (result: CategoryWithDepth[], category) => [
          ...result,
          { depth, ...category },
          ...treeToList(category.children || [], depth + 1),
        ],
        []
      )

    fetch(`/api/categories`).then(response =>
      response.json().then(categories => {
        setCategories(treeToList(categories))
      })
    )

  }, [setCategories])

  return categories
}
