// react
import React, { useEffect, useRef, useState } from 'react'
import { toast } from 'react-toastify'

type ActionFn = () => Promise<any>

type RenderFnProps = {
  run: () => void
  loading: boolean
}

export type RenderFn = (args: RenderFnProps) => React.ReactElement

export interface AsyncActionProps {
  action: ActionFn
  render: RenderFn
}

function AsyncAction(props: AsyncActionProps) {
  const { action, render } = props

  const [loading, setLoading] = useState(false)
  const canceledRef = useRef(false)

  const run = () => {
    if (loading || !action) {
      return
    }

    setLoading(true)

    action()
      .then(() => {
        if (canceledRef.current) {
          return
        }
      })
      .catch(e => {
        if (canceledRef.current) {
          return
        }

        toast.error(e.message, {
          position: 'top-right',
          autoClose: 5000,
          hideProgressBar: false,
          closeOnClick: true,
          pauseOnHover: true,
          draggable: true,
          progress: undefined,
        })
      })
      .finally(() => {
        setLoading(false)
      })
  }

  useEffect(
    () => () => {
      canceledRef.current = true
    },
    [canceledRef]
  )

  if (render) {
    return render({ run, loading })
  }

  return null
}

export default AsyncAction
