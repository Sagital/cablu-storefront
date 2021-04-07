import Head from 'next/head'
import React, { ComponentType, Fragment } from 'react'
import theme from '../components/theme'
import Header from '../components/Header'
import { CssBaseline } from '@material-ui/core'
import { makeStyles, MuiThemeProvider } from '@material-ui/core/styles'
import PWA from '../components/PWA'
import NavBar from '../components/NavBar'
import reportError from '../components/reportError'
import useAppStore from 'react-storefront/hooks/useAppStore'
import SessionProvider from '../context/SessionProvider'
import languages from '../i18n'
import '../scss/index.scss'
import Layout from '../components/Layout'
import { IntlProvider } from 'react-intl'
import { AppProps } from 'next/app'
import { NextComponentType, NextPageContext } from 'next'
import { AppContext } from 'next/dist/pages/_app'

export type StroykaAppProps = AppProps & {
  Component: NextComponentType<NextPageContext, any> & {
    Layout: ComponentType
  }
}

export default function MyApp({ Component, pageProps }: StroykaAppProps) {
  const [appData] = useAppStore(pageProps || {})
  const PageLayout = Component.Layout || Fragment
  const language = languages.find(x => x.locale === 'en')
  if (!language) {
    throw Error(`Language with locale: en not found!`)
  }

  return (
    <PWA errorReporter={reportError}>
      <Head>
        {/* <meta
          key="viewport"
          name="viewport"
          content="minimum-scale=1, initial-scale=1, width=device-width, shrink-to-fit=no"
        /> */}
      </Head>
      <SessionProvider url="/api/session">
        <IntlProvider locale="en" messages={language.messages}>
          <Layout headerLayout={'default'}>
            <PageLayout>
              <Component {...pageProps} />
            </PageLayout>
          </Layout>
        </IntlProvider>
      </SessionProvider>
    </PWA>
  )
}

MyApp.getInitialProps = async function({ Component, ctx }: AppContext) {
  let pageProps = {}

  if (Component.getInitialProps) {
    pageProps = await Component.getInitialProps(ctx)
  }

  return { pageProps }
}
