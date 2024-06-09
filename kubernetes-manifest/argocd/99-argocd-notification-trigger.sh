#!/bin/bash
SERVICE=${1}


if [ ${SERVICE} = "planner" ]
then
    kubectl -n argocd patch app planner \
    -p '{
        "metadata": {
            "annotations": {
                "notifications.argoproj.io/subscribe.on-sync-succeeded.slack":"planner-web",
                "notifications.argoproj.io/subscribe.on-sync-failed.slack":"planner-web",
                "notifications.argoproj.io/subscribe.on-sync-running.slack":"planner-web"
            }
        }
    }' --type merge
elif [ ${SERVICE} = "appadmin" ]
then
    kubectl -n argocd patch app appadmin \
    -p '{
        "metadata": {
            "annotations": {
                "notifications.argoproj.io/subscribe.on-sync-succeeded.slack":"appadmin",
                "notifications.argoproj.io/subscribe.on-sync-failed.slack":"appadmin",
                "notifications.argoproj.io/subscribe.on-sync-running.slack":"appadmin"
            }
        }
    }' --type merge
elif [ ${SERVICE} = "app" ]
then
    kubectl patch app app \
    -n argocd \
    -p '{
        "metadata": {
            "annotations": {
                "notifications.argoproj.io/subscribe.on-sync-succeeded.slack":"app-api",
                "notifications.argoproj.io/subscribe.on-sync-failed.slack":"app-api",
                "notifications.argoproj.io/subscribe.on-sync-running.slack":"app-api"
            }
        }
    }' --type merge
fi