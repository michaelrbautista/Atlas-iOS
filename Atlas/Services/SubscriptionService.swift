//
//  SubscriptionService.swift
//  Atlas
//
//  Created by Michael Bautista on 1/13/25.
//

import SwiftUI

final class SubscriptionService {
    
    public static let shared = SubscriptionService()
    
    // MARK: Get previous subscription
    public func getPreviousSubscription(subscriber: String, subscribedTo: String) async throws -> [CheckSubscription] {
        do {
            let subscriptions: [CheckSubscription] = try await SupabaseService.shared.supabase
                .from("subscriptions")
                .select("id")
                .eq("subscriber", value: subscriber)
                .eq("subscribed_to", value: subscribedTo)
                .execute()
                .value
            
            return subscriptions
        } catch {
            print(error)
            throw error
        }
    }
    
    // MARK: Unsubscribe
    public func unsubscribe(subscriber: String, subscribedTo: String) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("subscriptions")
                .update([
                    "is_active": "false"
                ])
                .eq("subscriber", value: subscriber)
                .eq("subscribed_to", value: subscribedTo)
                .execute()
        } catch {
            throw error
        }
    }
    
    // MARK: Update old subscription
    public func updateOldSubscription(subscriber: String, subscribedTo: String) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("subscriptions")
                .update([
                    "tier": "free",
                    "is_active": "true"
                ])
                .eq("subscriber", value: subscriber)
                .eq("subscribed_to", value: subscribedTo)
                .execute()
        } catch {
            throw error
        }
    }
    
    // MARK: New subscription
    public func createNewSubscription(newSubscription: NewSubscriptionRequest) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("subscriptions")
                .insert(newSubscription)
                .execute()
        } catch {
            throw error
        }
    }
    
    // MARK: Check if user is subscribed
    public func checkSubscription(userId: String, creatorId: String) async throws -> Bool {
        do {
            let subscription: [CheckSubscription] = try await SupabaseService.shared.supabase
                .from("subscriptions")
                .select("id")
                .eq("subscriber", value: userId)
                .eq("subscribed_to", value: creatorId)
                .eq("is_active", value: "true")
                .execute()
                .value
            
            if subscription.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            throw error
        }
    }
    
    // MARK: Get user's subscriptions
    public func getSubscriptions(userId: String, offset: Int) async throws -> [Subscription] {
        do {
            let subscriptions: [Subscription] = try await SupabaseService.shared.supabase
                .from("subscriptions")
                .select(
                    """
                        id,
                        subscriber,
                        subscribed_to:users!subscriptions_subscribed_to_fkey(
                            id,
                            full_name,
                            username,
                            profile_picture_url,
                            bio
                        ),
                        tier,
                        stripe_subscription_id,
                        stripe_customer_id,
                        stripe_price_id,
                        is_active
                    """
                )
                .eq("subscriber", value: userId)
                .eq("is_active", value: "true")
                .order("created_at", ascending: false)
                .range(from: offset, to: offset + 9)
                .execute()
                .value
            
            return subscriptions
        } catch {
            print(error)
            throw error
        }
    }
    
}
