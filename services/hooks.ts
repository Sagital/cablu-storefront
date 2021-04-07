import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { IProduct } from '../interfaces/product'

export function useMedia(query: string) {
  if (!process.browser) {
    return false
  }

  const media = useMemo(() => window.matchMedia(query), [query])
  const [state, setState] = useState(media.matches)

  useEffect(() => {
    const onChangeMedia = () => {
      setState(media.matches)
    }

    if (media.addEventListener) {
      media.addEventListener('change', onChangeMedia)
    } else {
      // noinspection JSDeprecatedSymbols
      media.addListener(onChangeMedia)
    }

    return () => {
      if (media.removeEventListener) {
        media.removeEventListener('change', onChangeMedia)
      } else {
        // noinspection JSDeprecatedSymbols
        media.removeListener(onChangeMedia)
      }
    }
  }, [media])

  return state
}

export type DeferredDataSource<T> = () => Promise<T>
export type DeferredDataState<T> = { isLoading: boolean; data: T }

export function useDeferredData<T>(
  source: DeferredDataSource<T>,
  defaultData: T,
  initialData?: T,
  deps: any[] = []
): DeferredDataState<T> {
  const [state, setState] = useState(() => ({
    isLoading: initialData === undefined,
    data: initialData || defaultData,
  }))
  const memoizedSource = useCallback(source, deps)
  const skipNextRef = useRef(initialData !== undefined)

  useEffect(() => {
    if (skipNextRef.current) {
      skipNextRef.current = false

      return () => {}
    }

    let canceled = false

    setState(curState => {
      if (!curState.isLoading) {
        return { ...curState, isLoading: true }
      }

      return curState
    })

    memoizedSource().then(data => {
      if (canceled) {
        return
      }

      setState(() => ({ isLoading: false, data }))
    })

    return () => {
      canceled = true
    }
  }, [memoizedSource])

  return state
}

export type ProductTab = { id: number; name: string }
export type WithCurrent<T> = T & { current: boolean }
export type ProductTabSource<T extends ProductTab> = (tab: T) => Promise<IProduct[]>
export type ProductTabsState<T extends ProductTab> = {
  tabs: WithCurrent<T>[]
  handleTabChange: (tab: WithCurrent<T>) => void
} & DeferredDataState<IProduct[]>

export function useProductTabs<T extends ProductTab>(
  tabs: T[],
  productsSource: ProductTabSource<T>,
  initialData?: IProduct[]
): ProductTabsState<T> {
  const [currentTabId, setCurrentTabId] = useState(1)
  const memoizedTabs = useMemo(
    () =>
      tabs.map(tab => ({
        ...tab,
        current: currentTabId === tab.id,
      })),
    [tabs, currentTabId]
  )
  const currentTab = memoizedTabs.find(x => x.current)
  const products = useDeferredData(
    () => (currentTab ? productsSource(currentTab) : Promise.resolve([])),
    [],
    initialData,
    [currentTab]
  )
  const handleTabChange = useCallback(
    tab => {
      setCurrentTabId(tab.id)
    },
    [setCurrentTabId]
  )

  return useMemo(
    () => ({
      tabs: memoizedTabs,
      handleTabChange,
      ...products,
    }),
    [memoizedTabs, handleTabChange, products]
  )
}

export type ProductColumn = {
  title: string
  source: DeferredDataSource<IProduct[]>
}

export function useProductColumns(columns: ProductColumn[]) {
  const products = useDeferredData(
    () => Promise.all(columns.map(column => column.source())),
    [],
    undefined,
    [columns]
  )

  return useMemo(
    () =>
      columns.map((column, index) => ({
        ...column,
        products: products.data[index] || [],
      })),
    [columns, products]
  )
}
