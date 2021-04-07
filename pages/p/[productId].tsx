import React, { useContext, useState, useEffect, useRef } from 'react'
import clsx from 'clsx'
import qs from 'qs'
import useLazyState from 'react-storefront/hooks/useLazyState'
import Breadcrumbs from 'react-storefront/Breadcrumbs'
import CmsSlot from 'react-storefront/CmsSlot'
import MediaCarousel from 'react-storefront/carousel/MediaCarousel'
import PWAContext from 'react-storefront/PWAContext'
import { Container, Grid, Typography, Hidden, Button } from '@material-ui/core'
import { Skeleton } from '@material-ui/lab'
import { makeStyles, useTheme } from '@material-ui/core/styles'
import Row from 'react-storefront/Row'
import { Hbox } from 'react-storefront/Box'
import Label from 'react-storefront/Label'
import Rating from 'react-storefront/Rating'
import get from 'lodash/get'
import fetch from 'react-storefront/fetch'
import { fetchLatest, StaleResponseError } from 'react-storefront/utils/fetchLatest'
import SessionContext from '../../context/SessionContext'
import AddToCartConfirmation from '../../components/product/AddToCartConfirmation'
import SuggestedProducts from '../../components/product/SuggestedProducts'
import Lazy from 'react-storefront/Lazy'
import TabPanel from 'react-storefront/TabPanel'
import QuantitySelector from 'react-storefront/QuantitySelector'
import ProductOptionSelector from 'react-storefront/option/ProductOptionSelector'
import fetchFromAPI from 'react-storefront/props/fetchFromAPI'
//import createLazyProps from 'react-storefront/props/createLazyProps'
import { IProduct } from '../../interfaces/product'
import { IShopCategory } from '../../interfaces/category'
import url from '../../services/url'
import { Fragment } from 'react'
import ProductTabs from '../../components/product/ProductTabs'
import BlockProductsCarousel from '../../components/blocks/BlockProductsCarousel'
import PageHeader from '../../components/shared/PageHeader'
import { Head } from 'next/document'
import ProductComponent from '../../components/shared/Product'

const fetchVariant = fetchLatest(fetch)

// const useDidMountEffect = (func, deps) => {
//   const didMount = useRef(false)
//   useEffect(() => {
//     if (didMount.current) {
//       func()
//     } else {
//       didMount.current = true
//     }
//   }, deps)
// }

const Product = React.memo((props: { loading: false }) => {
  const layout = 'standard'
  const sidebarPosition = 'start'

  const theme = useTheme()
  const [confirmationOpen, setConfirmationOpen] = useState(false)
  const [addToCartInProgress, setAddToCartInProgress] = useState(false)
  // const [state, updateState] = useLazyState(lazyProps, {
  //   pageData: { quantity: 1, carousel: { index: 0 } },
  // })

  const product = get(props, 'pageData.product') || {}
  const color = get(props, 'pageData.color') || {}
  const size = get(props, 'pageData.size') || {}
  const quantity = get(props, 'pageData.quantity')
  const { actions, session } = useContext(SessionContext)
  const { loading } = props

  const [relatedProducts, setRelatedProducts] = useState<IProduct[]>([])
  const [categories, setCategories] = useState<IShopCategory[]>([])
  const [latestProducts, setLatestProducts] = useState<IProduct[]>([])

  // This is provided when <ForwardThumbnail> is wrapped around product links
  const { thumbnail } = useContext(PWAContext)

  // Adds an item to the cart
  // const handleSubmit = async event => {
  //   event.preventDefault() // prevent the page location from changing
  //   setAddToCartInProgress(true) // disable the add to cart button until the request is finished
  //
  //   try {
  //     // send the data to the server
  //     await actions.addToCart({
  //       id: session.cart.id,
  //       product,
  //       quantity,
  //       color: color.id,
  //       size: size.id,
  //     })
  //
  //     // open the confirmation dialog
  //     setConfirmationOpen(true)
  //   } finally {
  //     // re-enable the add to cart button
  //     setAddToCartInProgress(false)
  //   }
  // }

  const breadcrumb = [
    { title: 'Home', url: url.home() },
    { title: 'Shop', url: url.catalog() },
    { title: product.name, url: url.product(product) },
  ]

  let content = (
    <Fragment>
      <div className="block">
        <div className="container">
          <ProductComponent product={product} layout={layout} loading={loading} />
          <ProductTabs />
        </div>
      </div>

      {/*{relatedProducts.length > 0 && (*/}
      {/*  <BlockProductsCarousel*/}
      {/*    title="Related Products"*/}
      {/*    layout="grid-5"*/}
      {/*    products={relatedProducts}*/}
      {/*  />*/}
      {/*)}*/}
    </Fragment>
  )

  return (
    <Fragment>
      {/*<Head>*/}
      {/*  <title>{`${product.name} — ${theme.name}`}</title>*/}
      {/*</Head>*/}

      <PageHeader breadcrumb={breadcrumb} />

      {content}
    </Fragment>
  )
  // const header = (
  //   <Row>
  //     <Typography variant="h6" component="h1" gutterBottom>
  //       {product ? product.name : <Skeleton style={{ height: '1em' }} />}
  //     </Typography>
  //     <Hbox>
  //       <Typography style={{ marginRight: theme.spacing(2) }}>{product.priceText}</Typography>
  //       <Rating value={product.rating} reviewCount={10} />
  //     </Hbox>
  //   </Row>
  // )
  //
  // // Fetch variant data upon changing color or size options
  // useDidMountEffect(() => {
  //   const query = qs.stringify({ color: color.id, size: size.id }, { addQueryPrefix: true })
  //   fetchVariant(`/api/p/${product.id}${query}`)
  //     .then(res => res.json())
  //     .then(data => {
  //       return updateState({ ...state, pageData: { ...state.pageData, ...data.pageData } })
  //     })
  //     .catch(e => {
  //       if (!StaleResponseError.is(e)) {
  //         throw e
  //       }
  //     })
  // }, [color.id, size.id])
  //
  // return (
  //   <>
  //     <Breadcrumbs items={!loading && state.pageData.breadcrumbs} />
  //     <Container maxWidth="lg" style={{ paddingTop: theme.spacing(2) }}>
  //       <form onSubmit={handleSubmit} method="post" action-xhr="/api/cart">
  //         <Grid container spacing={4}>
  //           <Grid item xs={12} sm={6} md={5}>
  //             <Hidden implementation="css" smUp>
  //               {header}
  //             </Hidden>
  //             <MediaCarousel
  //               className={classes.carousel}
  //               lightboxClassName={classes.lightboxCarousel}
  //               thumbnail={thumbnail.current}
  //               height="100%"
  //               media={color.media || (product && product.media)}
  //             />
  //           </Grid>
  //           <Grid item xs={12} sm={6} md={7}>
  //             <Grid container spacing={4}>
  //               <Grid item xs={12}>
  //                 <Hidden implementation="css" xsDown>
  //                   <div style={{ paddingBottom: theme.spacing(1) }}>{header}</div>
  //                 </Hidden>
  //                 {product ? (
  //                   <>
  //                     <Hbox style={{ marginBottom: 10 }}>
  //                       <Label>COLOR: </Label>
  //                       <Typography>{color.text}</Typography>
  //                     </Hbox>
  //                     <ProductOptionSelector
  //                       options={product.colors}
  //                       value={color}
  //                       onChange={value =>
  //                         updateState({ ...state, pageData: { ...state.pageData, color: value } })
  //                       }
  //                       strikeThroughDisabled
  //                       optionProps={{
  //                         showLabel: false,
  //                       }}
  //                     />
  //                   </>
  //                 ) : (
  //                   <div>
  //                     <Skeleton style={{ height: 14, marginBottom: theme.spacing(2) }}></Skeleton>
  //                     <Hbox>
  //                       <Skeleton style={{ height: 48, width: 48, marginRight: 10 }}></Skeleton>
  //                       <Skeleton style={{ height: 48, width: 48, marginRight: 10 }}></Skeleton>
  //                       <Skeleton style={{ height: 48, width: 48, marginRight: 10 }}></Skeleton>
  //                     </Hbox>
  //                   </div>
  //                 )}
  //               </Grid>
  //               <Grid item xs={12}>
  //                 {product ? (
  //                   <>
  //                     <Hbox style={{ marginBottom: 10 }}>
  //                       <Label>SIZE: </Label>
  //                       <Typography>{size.text}</Typography>
  //                     </Hbox>
  //                     <ProductOptionSelector
  //                       options={product.sizes}
  //                       value={size}
  //                       strikeThroughDisabled
  //                       onChange={value =>
  //                         updateState({ ...state, pageData: { ...state.pageData, size: value } })
  //                       }
  //                     />
  //                   </>
  //                 ) : (
  //                   <div>
  //                     <Skeleton style={{ height: 14, marginBottom: theme.spacing(2) }}></Skeleton>
  //                     <Hbox>
  //                       <Skeleton style={{ height: 48, width: 48, marginRight: 10 }}></Skeleton>
  //                       <Skeleton style={{ height: 48, width: 48, marginRight: 10 }}></Skeleton>
  //                       <Skeleton style={{ height: 48, width: 48, marginRight: 10 }}></Skeleton>
  //                     </Hbox>
  //                   </div>
  //                 )}
  //               </Grid>
  //               <Grid item xs={12}>
  //                 <Hbox>
  //                   <Label>QTY:</Label>
  //                   <QuantitySelector
  //                     value={quantity}
  //                     onChange={value =>
  //                       updateState({ ...state, pageData: { ...state.pageData, quantity: value } })
  //                     }
  //                   />
  //                 </Hbox>
  //               </Grid>
  //               <Grid item xs={12}>
  //                 <Button
  //                   key="button"
  //                   type="submit"
  //                   variant="contained"
  //                   color="primary"
  //                   size="large"
  //                   data-th="add-to-cart"
  //                   className={clsx(classes.docked, classes.noShadow)}
  //                   disabled={addToCartInProgress}
  //                 >
  //                   Add to Cart
  //                 </Button>
  //                 <AddToCartConfirmation
  //                   open={confirmationOpen}
  //                   setOpen={setConfirmationOpen}
  //                   product={product}
  //                   color={color}
  //                   size={size}
  //                   quantity={quantity}
  //                   price={product.priceText}
  //                 />
  //               </Grid>
  //             </Grid>
  //           </Grid>
  //         </Grid>
  //         <Grid item xs={12}>
  //           <TabPanel>
  //             <CmsSlot label="Description">{product.description}</CmsSlot>
  //             <CmsSlot label="Specs">{product.specs}</CmsSlot>
  //           </TabPanel>
  //         </Grid>
  //         <Grid item xs={12}>
  //           <Lazy style={{ minHeight: 285 }}>
  //             <SuggestedProducts product={product} />
  //           </Lazy>
  //         </Grid>
  //       </form>
  //     </Container>
  //   </>
})

// @ts-ignore
Product.getInitialProps = async context => {
  console.log('in product')
  console.log(context.pathname)
  console.log(context.query)
  console.log(context.asPath)

  const result = await fetchFromAPI(context)

  console.log(result)

  return result
}

export default Product
