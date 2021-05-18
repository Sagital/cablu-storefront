import React, { Fragment, useCallback, useEffect, useMemo, useState } from 'react'
import {  useTheme } from '@material-ui/core/styles'
import Head from 'next/head'
import categories from '../api/s/categories.json'

import qs from 'query-string'

import CategorySidebar from '../../components/subcategory/CategorySidebar'
import CategorySidebarItem from '../../components/subcategory/CategorySidebarItem'
import WidgetFilters from '../../components/widgets/WidgetFilters'
import BlockLoader from '../../components/blocks/BlockLoader'
import ProductsView, { ProductsViewGrid } from '../../components/subcategory/ProductsView'
import url from '../../services/url'
import PageHeader from '../../components/shared/PageHeader'
import { useRouter } from 'next/router'

const Subcategory = props => {

  const [sidebarOpen, setSidebarOpen] = useState(false)

  const [loading, setLoading] = useState(false)
  const [initialLoad, setInitialLoad] = useState(true)
  const [products, setProducts] = useState([])

  const [filterValues, setFilterValues] = useState(
    props.category.filters.reduce((acc, f) => {
      acc[f.slug] = []
      return acc
    }, {})
  )
  const [sortValue, setSortValue] = useState('default')

  const openSidebarFn = useCallback(() => setSidebarOpen(true), [setSidebarOpen])
  const closeSidebarFn = useCallback(() => setSidebarOpen(false), [setSidebarOpen])
  const filters = props.category.filters

  useEffect(() => {
    setLoading(true)

    const filters = Object.keys(filterValues)
      .filter(k => filterValues[k].length > 0)
      .reduce((acc, curr) => {
        acc[curr] = filterValues[curr]
        return acc
      }, {})

    fetch('/api/products', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        categoryIds: [props.category.id],
        filters,
        sort: sortValue,
      }),
    })
      .then(response => response.json())
      .then(products => {
        setProducts(products)
      })
      .finally(() => {
        setInitialLoad(false)
        setLoading(false)
      })
  }, [props.category, filterValues, sortValue])

  const onSortChange = sort => {
    setSortValue(sort)
  }

  const [latestProducts, setLatestProducts] = useState([])


  const onFiltersChanged = (filter, values) => {
    const newFilterValues = { ...filterValues, [filter.slug]: values }
    setFilterValues(newFilterValues)
  }

  const columns = 3
  const sidebarPosition = 'start'

  const theme = useTheme()
  const offcanvas = columns === 3 ? 'mobile' : 'always'
  const productsViewGrid = `grid-${columns}-${columns > 3 ? 'full' : 'sidebar'}`

  const sidebarComponent = useMemo(
    () => (
      <CategorySidebar open={sidebarOpen} closeFn={closeSidebarFn} offcanvas={offcanvas}>
        <CategorySidebarItem>
          <WidgetFilters
            title="Filters"
            filters={filters}
            filterValues={filterValues}
            offcanvas={offcanvas}
            category={props.category}
            onFiltersChanged={onFiltersChanged}
          />
        </CategorySidebarItem>
        {offcanvas !== 'always' && (
          <CategorySidebarItem className="d-none d-lg-block">
            {/*<WidgetProducts title="Latest Products" products={latestProducts} />*/}
          </CategorySidebarItem>
        )}
      </CategorySidebar>
    ),
    [sidebarOpen, closeSidebarFn, offcanvas, latestProducts, filters, filterValues]
  )

  // sidebar
  if (loading && initialLoad) {
    // TODO store reloading?
    return <BlockLoader />
  }

  const breadcrumb = [{ title: 'Home', url: url.home() }]
  breadcrumb.push({ title: props.category.name, url: { href: '/s/todo' } })

  let pageTitle = props.category.name

  let content

  const productsView = (
    <ProductsView
      layout="grid"
      grid={productsViewGrid}
      sortValue={sortValue}
      onSortChange={onSortChange}
      offcanvas={offcanvas}
      openSidebarFn={openSidebarFn}
      loading={loading}
      products={products}
      sort={sortValue}
    />
  )

  if (columns > 3) {
    content = (
      <div className="container">
        <div className="block">{productsView}</div>
        {sidebarComponent}
      </div>
    )
  } else {
    const sidebar = <div className="shop-layout__sidebar">{sidebarComponent}</div>

    content = (
      <div className="container">
        <div className={`shop-layout shop-layout--sidebar--${sidebarPosition}`}>
          {sidebarPosition === 'start' && sidebar}
          <div className="shop-layout__content">
            <div className="block">{productsView}</div>
          </div>
          {sidebarPosition === 'end' && sidebar}
        </div>
      </div>
    )
  }

  return (
    <>
      {/*<Breadcrumbs items={!loading && pageData.breadcrumbs} />*/}

      <Fragment>
        <Head>
          <title>{`Shop Category Page — ${theme.name}`}</title>
        </Head>

        <PageHeader header={pageTitle} breadcrumb={breadcrumb} />

        {content}
      </Fragment>


    </>
  )
}

export default Subcategory
