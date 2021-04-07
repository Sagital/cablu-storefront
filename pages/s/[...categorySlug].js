import React, { useCallback, useMemo, useState } from 'react'
import { Typography, Grid, Container, Hidden } from '@material-ui/core'
import { makeStyles, useTheme } from '@material-ui/core/styles'
import ResponsiveTiles from 'react-storefront/ResponsiveTiles'
import ProductItem from '../../components/product/ProductItem'
import ShowMore from 'react-storefront/plp/ShowMore'
import Head from 'next/head'
import BackToTop from 'react-storefront/BackToTop'
import { Skeleton } from '@material-ui/lab'
import { Hbox } from 'react-storefront/Box'
import Breadcrumbs from 'react-storefront/Breadcrumbs'
import LoadMask from 'react-storefront/LoadMask'
import useSearchResultsStore from 'react-storefront/plp/useSearchResultsStore'
import Filter from 'react-storefront/plp/Filter'
import SearchResultsProvider from 'react-storefront/plp/SearchResultsProvider'
import ProductOptionSelector from 'react-storefront/option/ProductOptionSelector'
import FilterButton from 'react-storefront/plp/FilterButton'
import SortButton from 'react-storefront/plp/SortButton'
import Fill from 'react-storefront/Fill'
import fetchFromAPI from 'react-storefront/props/fetchFromAPI'
import createLazyProps from 'react-storefront/props/createLazyProps'
import CategorySidebar from '../../components/subcategory/CategorySidebar'
import CategorySidebarItem from '../../components/subcategory/CategorySidebarItem'
import ShopPageCategory from '../../components/subcategory/ShopPageCategory'

const useStyles = makeStyles(theme => ({
  sideBar: {
    margin: theme.spacing(0, 4, 0, 0),
    width: 275,
  },
  sortButton: {
    [theme.breakpoints.down('xs')]: {
      flex: 1,
    },
  },
  total: {
    marginTop: theme.spacing(1),
  },
}))

const Subcategory = lazyProps => {
  const [store, updateStore] = useSearchResultsStore(lazyProps)

  const classes = useStyles()
  const { columns = 3, viewMode, sidebarPosition = 'start' } = lazyProps
  const theme = useTheme()
  let { pageData, loading } = store
  // sidebar
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const openSidebarFn = useCallback(() => setSidebarOpen(true), [setSidebarOpen])
  const closeSidebarFn = useCallback(() => setSidebarOpen(false), [setSidebarOpen])
  const offcanvas = columns === 3 ? 'mobile' : 'always'
  const [latestProducts, setLatestProducts] = useState([])

  const sidebarComponent = useMemo(
    () => (
      <CategorySidebar open={sidebarOpen} closeFn={closeSidebarFn} offcanvas={offcanvas}>
        <CategorySidebarItem></CategorySidebarItem>
        {offcanvas !== 'always' && (
          <CategorySidebarItem className="d-none d-lg-block"></CategorySidebarItem>
        )}
      </CategorySidebar>
    ),
    [sidebarOpen, closeSidebarFn, offcanvas, latestProducts]
  )

  // if (pageData.isLanding) {
  //   return (
  //     <>
  //       <Breadcrumbs items={!loading && pageData.breadcrumbs} />
  //       <Grid item xs={12}>
  //         {!loading ? (
  //           <Typography
  //             component="h1"
  //             variant="h4"
  //             gutterBottom
  //             align="center"
  //             className={classes.landingTitleSpacing}
  //           >
  //             {pageData.name}
  //           </Typography>
  //         ) : (
  //           <Skeleton height={32} style={{ marginBottom: theme.spacing(1) }} />
  //         )}
  //       </Grid>
  //       {!loading && <LandingCmsSlots cmsBlocks={pageData.cmsBlocks} />}
  //     </>
  //   )
  // }

  // Here is an example of how you can customize the URL scheme for filtering and sorting - /s/1?color=red,blue=sort=pop
  // Note that if you change this, you also need to change pages/api/[...categorySlug].js to correctly handle the query parameters
  // you send it.
  const queryForState = useCallback(state => {
    const { filters, page, sort } = state
    const query = {}

    for (let filter of filters) {
      const [name, value] = filter.split(':')

      console.log(name, value)

      if (query[name]) {
        query[name] = `${query[name]},${value}`
      } else {
        query[name] = value
      }
    }

    if (query.more) {
      delete query.more
    }

    if (page > 0) {
      query.page = page
    } else {
      delete query.page
    }

    if (sort) {
      query.sort = sort
    } else {
      delete query.sort
    }

    console.log('query', query)

    return query
  }, [])

  return (
    <>
      {/*<Breadcrumbs items={!loading && pageData.breadcrumbs} />*/}

      <ShopPageCategory
        columns={3}
        viewMode="grid"
        sidebarPosition="start"
        store={store}
        updateStore={updateStore}
      />
    </>
  )
}

Subcategory.getInitialProps = createLazyProps(opts => {
  const { res } = opts
  if (res) res.setHeader('Cache-Control', 'max-age=99999')
  return fetchFromAPI(opts)
})

export default Subcategory
