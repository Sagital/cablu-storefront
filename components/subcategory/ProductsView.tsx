// react
import React, { ReactNode, useState } from 'react'

// third-party
import classNames from 'classnames'

// application
import Filters16Svg from '../../svg/filters-16.svg'
import LayoutGrid16x16Svg from '../../svg/layout-grid-16x16.svg'
import LayoutGridWithDetails16x16Svg from '../../svg/layout-grid-with-details-16x16.svg'
import LayoutList16x16Svg from '../../svg/layout-list-16x16.svg'
import Pagination from '../shared/Pagination'
import ProductCard from '../shared/ProductCard'
import { IProductsList } from '../../interfaces/product'
// import {
//   useSetOption,
//   useShopFilterValues,
//   useShopOptions,
//   useShopProductsList,
//   useShopProductsListIsLoading,
//   useShopResetFiltersThunk,
// } from '../../store/shop/shopHooks'

export type ProductsViewLayout = 'grid' | 'grid-with-features' | 'list'

export type ProductsViewGrid = 'grid-3-sidebar' | 'grid-4-full' | 'grid-5-full'

type ProductsViewOffcanvas = 'always' | 'mobile'

interface ProductsViewProps {
  layout?: ProductsViewLayout
  grid?: ProductsViewGrid
  offcanvas?: ProductsViewOffcanvas
  sortValue: string
  onSortChange: (sort: string) => {}
  openSidebarFn?: () => void
  store: any
}

interface ViewMode {
  key: ProductsViewLayout
  title: string
  icon: ReactNode
}

function ProductsView(props: ProductsViewProps) {
  const {
    layout: propsLayout = 'grid',
    grid = 'grid-3-sidebar',
    offcanvas = 'mobile',
    store,
    openSidebarFn,
  } = props
  const [layout, setLayout] = useState(propsLayout)

  const isLoading = store.loading
  // const productsList = useShopProductsList();
  const productsList: IProductsList = {
    filters: [],
    from: 1,
    limit: 0,
    page: 0,
    pages: 0,
    sort: store.pageData.sort || 'default',
    to: store.pageData.products.length,
    total: store.pageData.products.length,
    items: store.pageData.products,
  }

  // const filterValues = useShopFilterValues()
  //
  // const handlePageChange = useSetOption('page', parseFloat)
  const handleSortChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    props.onSortChange(e.target.value)
  }
  // const handleLimitChange = useSetOption('limit', event => parseFloat(event.target.value))

  //  const shopResetFilters = useShopResetFiltersThunk()

  if (productsList === null) {
    return null
  }

  // const filtersCount = Object.keys(filterValues)
  //   .map(x => filterValues[x])
  //   .filter(x => x).length
  const viewModesDef: ViewMode[] = [
    { key: 'grid', title: 'Grid', icon: <LayoutGrid16x16Svg /> },
    {
      key: 'grid-with-features',
      title: 'Grid With Features',
      icon: <LayoutGridWithDetails16x16Svg />,
    },
    { key: 'list', title: 'List', icon: <LayoutList16x16Svg /> },
  ]
  const viewModes = viewModesDef.map(viewMode => {
    const className = classNames('layout-switcher__button', {
      'layout-switcher__button--active': layout === viewMode.key,
    })

    return (
      <button
        key={viewMode.key}
        title={viewMode.title}
        type="button"
        className={className}
        onClick={() => setLayout(viewMode.key)}
      >
        {viewMode.icon}
      </button>
    )
  })

  const productsListItems = productsList.items.map(product => (
    <div key={product.id} className="products-list__item">
      <ProductCard product={product} />
    </div>
  ))

  const rootClasses = classNames('products-view', {
    'products-view--loading': isLoading,
  })

  const viewOptionsClasses = classNames('view-options', {
    'view-options--offcanvas--always': offcanvas === 'always',
    'view-options--offcanvas--mobile': offcanvas === 'mobile',
  })

  let content

  if (productsListItems.length > 0) {
    content = (
      <div className="products-view__content">
        <div className="products-view__options">
          <div className={viewOptionsClasses}>
            <div className="view-options__filters-button">
              <button type="button" className="filters-button" onClick={openSidebarFn}>
                <Filters16Svg className="filters-button__icon" />
                <span className="filters-button__title">Filters</span>
                {/*{!!filtersCount && <span className="filters-button__counter">{filtersCount}</span>}*/}
              </button>
            </div>
            <div className="view-options__layout">
              <div className="layout-switcher">
                <div className="layout-switcher__list">{viewModes}</div>
              </div>
            </div>
            <div className="view-options__legend">
              {`Showing ${productsList.from}—${productsList.to} of ${productsList.total} products`}
            </div>
            <div className="view-options__divider" />
            <div className="view-options__control">
              <label htmlFor="view-options-sort">Sort By</label>
              <div>
                <select
                  id="view-options-sort"
                  className="form-control form-control-sm"
                  value={props.sortValue}
                  onChange={handleSortChange}
                >
                  <option value="default">Default</option>
                  <option value="name_asc">Name (A-Z)</option>
                  <option value="name_desc">Name (Z-A)</option>
                </select>
              </div>
            </div>
            <div className="view-options__control">
              <label htmlFor="view-options-limit">Show</label>
              <div>
                <select
                  id="view-options-limit"
                  className="form-control form-control-sm"
                  // value={options.limit || productsList.limit}
                  // onChange={handleLimitChange}
                >
                  <option value="12">12</option>
                  <option value="18">18</option>
                  <option value="24">24</option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <div
          className="products-view__list products-list"
          data-layout={layout !== 'list' ? grid : layout}
          data-with-features={layout === 'grid-with-features' ? 'true' : 'false'}
        >
          <div className="products-list__body">{productsListItems}</div>
        </div>

        <div className="products-view__pagination">
          <Pagination
            // current={options.page || productsList.page}
            siblings={2}
            total={productsList.pages}
            // onPageChange={handlePageChange}
          />
        </div>
      </div>
    )
  } else {
    content = (
      <div className="products-view__empty">
        <div className="products-view__empty-title">No matching items</div>
        <div className="products-view__empty-subtitle">Try resetting the filters</div>
        {/*<button type="button" className="btn btn-primary btn-sm" onClick={shopResetFilters}>*/}
        {/*  Reset filters*/}
        {/*</button>*/}
      </div>
    )
  }

  return (
    <div className={rootClasses}>
      <div className="products-view__loader" />
      {content}
    </div>
  )
}

export default ProductsView
