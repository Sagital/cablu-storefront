import React from 'react'
import useLazyState from 'react-storefront/hooks/useLazyState'
import LoadMask from 'react-storefront/LoadMask'
import Head from 'next/head'
import createLazyProps from 'react-storefront/props/createLazyProps'
import fetchFromAPI from 'react-storefront/props/fetchFromAPI'
import BlockSlideShow from '../components/blocks/BlockSlideShow'

// const useStyles = makeStyles(theme => ({
//   main: {
//     display: 'flex',
//     alignItems: 'center',
//     flexDirection: 'column',
//     textAlign: 'center',
//     margin: theme.spacing(10, 0, 0, 0),
//   },
// }))

// export const getServerSideProps: GetServerSideProps<PageProps> = async () => ({
//   props: {
//     initData: {
//       featuredProducts: await shopApi.getPopularProducts({ limit: 8 }),
//       bestsellers: await shopApi.getPopularProducts({ limit: 7 }),
//       latestProducts: await shopApi.getLatestProducts({ limit: 8 }),
//       productColumns: [
//         {
//           title: 'Top Rated Products',
//           products: await shopApi.getTopRatedProducts({ limit: 3 }),
//         },
//         {
//           title: 'Special Offers',
//           products: await shopApi.getDiscountedProducts({ limit: 3 }),
//         },
//         {
//           title: 'Bestsellers',
//           products: await shopApi.getPopularProducts({ limit: 3 }),
//         },
//       ],
//     },
//   },
// })

export default function Index(lazyProps) {
  const [state] = useLazyState(lazyProps)

  return (
    <>
      {state.loading ? null : (
        <Head>
          <title>{state.pageData.title}</title>
        </Head>
      )}

      {state.loading ? (
        <LoadMask fullscreen />
      ) : (
        <>
          <BlockSlideShow withDepartments />
        </>
      )}
    </>
  )
}

Index.getInitialProps = createLazyProps(options => {
  const { res } = options
  if (res) res.setHeader('Cache-Control', 'max-age=99999')
  return fetchFromAPI(options)
})
