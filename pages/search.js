import fetchFromAPI from 'react-storefront/props/fetchFromAPI'
import createLazyProps from 'react-storefront/props/createLazyProps'
import ProductsView from '../components/subcategory/ProductsView'
import React, { Fragment } from 'react'

import useLazyState from 'react-storefront/hooks/useLazyState'
import BlockLoader from '../components/blocks/BlockLoader'
import url from '../services/url'
import Head from 'next/head'
import PageHeader from '../components/shared/PageHeader'

const Search = lazyProps => {
  const [state] = useLazyState(lazyProps)

  // sidebar
  if (state.loading) {
    // TODO store reloading?
    return <BlockLoader />
  }

  const breadcrumb = [{ title: 'Home', url: url.home() }]
  breadcrumb.push({ title: 'Search', url: { href: '/search' } })

  return (
    <Fragment>
      <Head>
        <title>{`Shop Category Page — Search`}</title>
      </Head>

      <PageHeader header={'Search Results'} breadcrumb={breadcrumb} />
      <div className="container">
        <div className="block">
          <ProductsView
            sort={''}
            grid="grid-4-full"
            openSidebarFn={() => {}}
            loading={state.loading}
            products={state.pageData.products || []}
            onSortChange={() => {}}
          />
        </div>
      </div>
    </Fragment>
  )
}

Search.getInitialProps = createLazyProps(opts => {
  opts.asPath = `/search?${opts.asPath.split('?')[1]}`
  return fetchFromAPI(opts)
})

export default Search
