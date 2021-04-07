// react
import { Fragment } from 'react'
import { ICurrency } from '../../interfaces/currency'

// application

export interface CurrencyFormatProps {
  value: number
  currency?: ICurrency
}

function CurrencyFormat(props: CurrencyFormatProps) {
  const { value, currency } = props
  const currentCurrency = { code: 'RON', symbol: 'RON', name: 'RON' }
  const { symbol } = currency || currentCurrency

  return <Fragment>{`${symbol}${value.toFixed(2)}`}</Fragment>
}

export default CurrencyFormat
