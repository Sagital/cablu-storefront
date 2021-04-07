// react
import React, { useEffect, useRef, useState } from 'react';

type ActionFn = () => Promise<any>;

type RenderFnProps = {
    run: () => void;
    loading: boolean;
};

export type RenderFn = (args: RenderFnProps) => React.ReactElement;

export interface AsyncActionProps {
    action: ActionFn;
    render: RenderFn;
}

function AsyncAction(props: AsyncActionProps) {
    const { action, render } = props;
    const [loading, setLoading] = useState(false);
    const canceledRef = useRef(false);

    const run = () => {
        if (loading || !action) {
            return;
        }

        setLoading(true);

        action().then(() => {
            if (canceledRef.current) {
                return;
            }

            setLoading(false);
        });
    };

    useEffect(() => () => {
        canceledRef.current = true;
    }, [canceledRef]);

    if (render) {
        return render({ run, loading });
    }

    return null;
}

export default AsyncAction;
