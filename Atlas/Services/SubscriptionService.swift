//
//  SubscriptionService.swift
//  Atlas
//
//  Created by Michael Bautista on 1/13/25.
//

import SwiftUI

final class SubscriptionService {
    
    public static let shared = SubscriptionService()
    
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
