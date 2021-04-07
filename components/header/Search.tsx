// react
import {
  ChangeEvent,
  KeyboardEvent,
  RefObject,
  useCallback,
  useEffect,
  useRef,
  useState,
} from 'react'

// third-party
import classNames from 'classnames'
import { useRouter } from 'next/router'

// application
import Cross20Svg from '../../svg/cross-20.svg'
import Search20Svg from '../../svg/search-20.svg'
// import shopApi, { GetSuggestionsOptions } from '../../api/shop';
import Suggestions from './Suggestions'
import { ICategory } from '../../interfaces/category'
import { IProduct } from '../../interfaces/product'

type CategoryWithDepth = ICategory & { depth: number }

function useCategories() {
  const [categories, setCategories] = useState<CategoryWithDepth[]>([])

  useEffect(() => {
    let canceled = false

    const treeToList = (categories: ICategory[], depth = 0): CategoryWithDepth[] =>
      categories.reduce(
        (result: CategoryWithDepth[], category) => [
          ...result,
          { depth, ...category },
          ...treeToList(category.children || [], depth + 1),
        ],
        []
      )

    // shopApi.getCategories({ depth: 1 }).then((categories: ICategory[]) => {
    //   if (canceled) {
    //     return
    //   }
    //
    //   setCategories(treeToList(categories))
    // })

    return () => {
      canceled = true
    }
  }, [setCategories])

  return categories
}

export interface SearchProps {
  context: 'header' | 'mobile-header' | 'indicator'
  className?: string
  inputRef?: RefObject<HTMLInputElement>
  onClose?: () => void
}

function Search(props: SearchProps) {
  const { context, className, inputRef, onClose } = props
  const [cancelFn, setCancelFn] = useState(() => () => {})
  const [suggestionsOpen, setSuggestionsOpen] = useState(false)
  const [hasSuggestions, setHasSuggestions] = useState(false)
  const [suggestedProducts, setSuggestedProducts] = useState<IProduct[]>([])
  const [query, setQuery] = useState('')
  const [category, setCategory] = useState('[all]')
  const categories = useCategories()
  const wrapperRef = useRef<HTMLDivElement>(null)
  const router = useRouter()
  const close = useCallback(() => {
    if (onClose) {
      onClose()
    }

    setSuggestionsOpen(false)
  }, [onClose])

  // Close suggestions when the location has been changed.
  useEffect(() => close(), [close, router.asPath])

  // Close suggestions when a click has been made outside component.
  useEffect(() => {
    const onGlobalClick = (event: MouseEvent) => {
      if (wrapperRef.current && !wrapperRef.current.contains(event.target as HTMLElement)) {
        close()
      }
    }

    document.addEventListener('mousedown', onGlobalClick)

    return () => document.removeEventListener('mousedown', onGlobalClick)
  }, [close])

  // Cancel previous typing.
  useEffect(() => () => cancelFn(), [cancelFn])

  const handleFocus = () => {
    setSuggestionsOpen(true)
  }

  const handleChangeCategory = (event: ChangeEvent<HTMLSelectElement>) => {
    setCategory(event.target.value)
  }

  const handleChangeQuery = (event: ChangeEvent<HTMLInputElement>) => {
    let canceled = false
    let timer: ReturnType<typeof setTimeout>

    const newCancelFn = () => {
      canceled = true
      clearTimeout(timer)
    }

    const query = event.target.value

    setQuery(query)

    if (query === '') {
      setHasSuggestions(false)
    } else {
      timer = setTimeout(() => {
        // const options: GetSuggestionsOptions = { limit: 5 }
        //
        // if (category !== '[all]') {
        //   options.category = category
        // }
        //
        // shopApi.getSuggestions(query, options).then(products => {
        //   if (canceled) {
        //     return
        //   }
        //
        //   setSuggestedProducts(products)
        //   setHasSuggestions(products.length > 0)
        //   setSuggestionsOpen(true)
        // })
      }, 100)
    }

    setCancelFn(() => newCancelFn)
  }

  const handleBlur = () => {
    setTimeout(() => {
      if (!document.activeElement || document.activeElement === document.body) {
        return
      }

      // Close suggestions if the focus received an external element.
      if (wrapperRef.current && !wrapperRef.current.contains(document.activeElement)) {
        close()
      }
    }, 10)
  }

  // Close suggestions when the Escape key has been pressed.
  const handleKeyDown = (event: KeyboardEvent<HTMLInputElement>) => {
    // Escape.
    if (event.which === 27) {
      close()
    }
  }

  const rootClasses = classNames(`search search--location--${context}`, className, {
    'search--suggestions-open': suggestionsOpen,
    'search--has-suggestions': hasSuggestions,
  })

  const closeButton =
    context !== 'mobile-header' ? (
      ''
    ) : (
      <button className="search__button search__button--type--close" type="button" onClick={close}>
        <Cross20Svg />
      </button>
    )

  const categoryOptions = categories.map(category => (
    <option key={category.slug} value={category.slug}>
      {'\u00A0'.repeat(4 * category.depth)}
      {category.name}
    </option>
  ))

  return (
    <div className={rootClasses} ref={wrapperRef} onBlur={handleBlur}>
      <div className="search__body">
        <form className="search__form" action="">
          {context === 'header' && (
            <select
              className="search__categories"
              aria-label="Category"
              value={category}
              onFocus={close}
              onChange={handleChangeCategory}
            >
              <option value="[all]">All Categories</option>
              {categoryOptions}
            </select>
          )}
          <input
            ref={inputRef}
            onChange={handleChangeQuery}
            onFocus={handleFocus}
            onKeyDown={handleKeyDown}
            value={query}
            className="search__input"
            name="search"
            placeholder="Search over 10,000 products"
            aria-label="Site search"
            type="text"
            autoComplete="off"
          />
          <button className="search__button search__button--type--submit" type="submit">
            <Search20Svg />
          </button>
          {closeButton}
          <div className="search__border" />
        </form>

        <Suggestions
          className="search__suggestions"
          context={context}
          products={suggestedProducts}
        />
      </div>
    </div>
  )
}

export default Search
