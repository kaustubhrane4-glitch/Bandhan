// ── SUPABASE CLIENT CONFIGURATION ─────────────────────────────────────────
// Replace the placeholders below with your actual Supabase credentials.
// You can find these in your Supabase Project Settings -> API.

import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jrtyluvpgaizsgvyurnot.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpydHlsdXZwZ2F6c2d2eXVybm90Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgzODUyMDksImV4cCI6MjA5Mzk2MTIwOX0.Hukc5tUpMumdkcM7dK5zXDFesQzBjNizK2CpSXH5eIE';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// ── HELPER FUNCTIONS ────────────────────────────────────────────────────────

/**
 * Fetch the current user's profile.
 */
export async function getProfile() {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single();

  if (error) throw error;
  return data;
}

/**
 * Fetch active bonds (contracts) for the user.
 */
export async function getMyBonds() {
  const { data, error } = await supabase
    .from('bonds')
    .select('*, expert:expert_id(full_name, avatar_url), service:service_id(name)')
    .eq('status', 'active');

  if (error) throw error;
  return data;
}

/**
 * Create a new booking.
 */
export async function createBooking(bookingData) {
  const { data, error } = await supabase
    .from('bookings')
    .insert([bookingData])
    .select();

  if (error) throw error;
  return data;
}

/**
 * Fetch the user's current wallet balance.
 */
export async function getWalletBalance() {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return 0;
  const { data } = await supabase.from('profiles').select('wallet_balance').eq('id', user.id).single();
  return data?.wallet_balance || 0;
}

/**
 * Fetch wallet transaction history.
 */
export async function getWalletHistory() {
  const { data, error } = await supabase
    .from('wallet_transactions')
    .select('*')
    .order('created_at', { ascending: false });

  if (error) throw error;
  return data;
}

/**
 * Add a mock transaction (for top-ups/payouts).
 */
export async function addTransaction(amount, type, description) {
  const { data: { user } } = await supabase.auth.getUser();
  const { data, error } = await supabase
    .from('wallet_transactions')
    .insert([{ profile_id: user.id, amount, type, description }])
    .select();
  if (error) throw error;
  return data;
}

/**
 * Send an OTP to the user's email or phone.
 */
export async function signInWithOtp(value, type = 'phone') {
  const { data, error } = await supabase.auth.signInWithOtp({
    [type]: value,
  });
  if (error) throw error;
  return data;
}

/**
 * Verify the OTP token.
 */
export async function verifyOtp(value, token, type = 'phone') {
  const { data, error } = await supabase.auth.verifyOtp({
    [type]: value,
    token,
    type: type === 'phone' ? 'sms' : 'email',
  });
  if (error) throw error;
  return data;
}

/**
 * Sign out the current user.
 */
export async function signOutUser() {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
}

/**
 * Submit a review for a booking.
 */
export async function submitReview(reviewData) {
  const { data, error } = await supabase
    .from('reviews')
    .insert([reviewData])
    .select();
  if (error) throw error;
  return data;
}

/**
 * Fetch reviews for a specific provider.
 */
export async function getProviderReviews(providerId) {
  const { data, error } = await supabase
    .from('reviews')
    .select('*, profiles:from_id(full_name, avatar_url)')
    .eq('to_id', providerId)
    .order('created_at', { ascending: false });
  if (error) throw error;
  return data;
}

/**
 * Fetch booking history for the current user.
 */
export async function getMyBookings() {
  const { data, error } = await supabase
    .from('bookings')
    .select('*, service:service_id(name, icon_emoji), expert:expert_id(full_name, avatar_url)')
    .order('created_at', { ascending: false });
  if (error) throw error;
  return data;
}
